import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/enums/user_enum.dart';
import 'package:ride_usuario/models/auth_response.dart';
import 'package:ride_usuario/models/user_data.dart';
import 'package:ride_usuario/services/login_service.dart';
import 'package:ride_usuario/services/referred_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/pages/home/home_page.dart';
import 'package:ride_usuario/utils/flash_message.dart';

import '/utils/button.dart' as btn;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final LoginService _loginService = LoginService();
  final ReferredService _referredService = ReferredService();

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerCodeReference =
      TextEditingController();

  PreferenciasUsuario prefs = PreferenciasUsuario();

  String? _errorName;
  String? _errorLastName;
  String? _errorEmail;

  @override
  void initState() {
    super.initState();
    _controllerName.addListener(() => _validateName());
    _controllerLastName.addListener(() => _validateLastName());
    _controllerEmail.addListener(() => _validateEmail());
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerLastName.dispose();
    _controllerEmail.dispose();
    _controllerCodeReference.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      _errorName =
          _controllerName.text.isEmpty ? 'El nombre es obligatorio' : null;
    });
  }

  void _validateLastName() {
    setState(() {
      _errorLastName = _controllerLastName.text.isEmpty
          ? 'El apellido es obligatorio'
          : null;
    });
  }

  void _validateEmail() {
    setState(() {
      if (_controllerEmail.text.isEmpty) {
        _errorEmail = 'El correo es obligatorio';
      } else if (!_isValidEmail(_controllerEmail.text)) {
        _errorEmail = 'Ingresa un correo válido';
      } else {
        _errorEmail = null;
      }
    });
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool _validateForm() {
    _validateName();
    _validateLastName();
    _validateEmail();

    return _errorName == null && _errorLastName == null && _errorEmail == null;
  }

  void createUser() async {
    print('tokenFirebase ${prefs.tokenFirebase}');
    print('fcmToken ${prefs.fcmToken}');
    print('phoneNumber ${prefs.phoneNumber}');
    print('email ${_controllerEmail.text.trim()}');
    print('name ${_controllerName.text.trim()}');
    print('lastName ${_controllerLastName.text.trim()}');
    print('role ${UserRole.passenger}');
    print('authType ${AuthType.mobile}');
    if (_validateForm()) {
      final responseLogin = await _loginService.authLogin(
        UserData(
          idToken: prefs.tokenFirebase,
          pnToken: prefs.fcmToken,
          mobile: prefs.phoneNumber,
          email: _controllerEmail.text.trim(),
          firstName: _controllerName.text.trim(),
          lastName: _controllerLastName.text.trim(),
          role: UserRole.passenger,
          authType: AuthType.mobile,
        ),
      );

      if (responseLogin.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(responseLogin.data);
        prefs.saveUserData(
          idUser: authResponse.data.user.id.toString(),
          email: authResponse.data.user.email,
          firstName: authResponse.data.user.firstName,
          lastName: authResponse.data.user.lastName,
          phoneNumber: authResponse.data.user.mobile,
          accessToken: authResponse.data.accessToken,
          refreshToken: authResponse.data.refreshToken,
        );

        await generateCodeReferred(
          authResponse.data.user.id.toString(),
          authResponse.data.accessToken,
        );
      } else {
        print('Error: Código de estado no es 201');
      }
    }
  }

  Future<void> generateCodeReferred(String idUser, String token) async {
    final result = await _referredService.generateReferred(idUser, token);
    if (result.isSuccess) {
      prefs.referralCode = result.data!.data.code;

      if (_controllerCodeReference.text.isEmpty) {
        prefs.isAuthenticated = true;

        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        int idUserInt = int.parse(idUser);
        await codeReferred(idUserInt, token);
      }
    } else {
      mensaje(3, context, TypeMessage.danger, 'Error al generar código');
    }
  }

  Future<void> codeReferred(int idUser, String token) async {
    final code = _controllerCodeReference.text.trim();
    final result = await _referredService.postRefer(code, idUser, token);
    if (result.isSuccess) {
      prefs.isAuthenticated = true;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      print('Error post refer: ${result.error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xffF7F7F7)
                                        .withOpacity(0.8),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Ingresa tus datos',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 11),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 37.0),
                              child: Text(
                                'Por favor, ingresa tu nombre real para brindar confianza a los conductores',
                                style: TextStyle(
                                  color:
                                      const Color(0xff2D2D31).withOpacity(0.6),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 46),
                            _buildTextField(
                              controller: _controllerName,
                              hintText: 'Nombre',
                              svgIcon: 'assets/img/name_user.svg',
                              errorText: _errorName,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _controllerLastName,
                              hintText: 'Apellido',
                              svgIcon: 'assets/img/last_name_user.svg',
                              errorText: _errorLastName,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _controllerEmail,
                              hintText: 'Correo electrónico',
                              svgIcon: 'assets/img/name_user.svg',
                              errorText: _errorEmail,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 37.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Opcional',
                                    style: TextStyle(
                                      color: AppColors.black60,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            _buildTextField(
                              controller: _controllerCodeReference,
                              hintText: 'Código de referencia',
                              svgIcon: 'assets/img/name_user.svg',
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Container()), // Espacio expandible
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: btn.button(
                          label: 'Confirmar',
                          onPressed: createUser,
                          type: 'black',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String svgIcon,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 37.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: SvgPicture.asset(
                      svgIcon,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: const Color(0xff141414).withOpacity(0.25),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
