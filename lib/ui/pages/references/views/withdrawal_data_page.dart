import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/models/auth_response.dart';
import 'package:ride_usuario/models/user_data.dart';
import 'package:ride_usuario/services/login_service.dart';
import 'package:ride_usuario/services/referred_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/utils/flash_message.dart';

import '/utils/button.dart' as btn;

class WithdrawalDataPage extends StatefulWidget {
  const WithdrawalDataPage({super.key});

  @override
  State<WithdrawalDataPage> createState() => _WithdrawalDataPageState();
}

class _WithdrawalDataPageState extends State<WithdrawalDataPage> {
  final LoginService _loginService = LoginService();
  final ReferredService _referredService = ReferredService();

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerCCI = TextEditingController();
  final TextEditingController _controllerDNI = TextEditingController();
  final TextEditingController _controllerAlias = TextEditingController();

  PreferenciasUsuario prefs = PreferenciasUsuario();

  String? _errorName;
  String? _errorEmail;
  String? _errorCCI;
  String? _errorDNI;
  String? _errorAlias;

  @override
  void initState() {
    super.initState();
    _controllerName.addListener(() => _validateName());
    _controllerEmail.addListener(() => _validateEmail());
    _controllerCCI.addListener(() => _validateCCI());
    _controllerDNI.addListener(() => _validateDNI());
    _controllerAlias.addListener(() => _validateAlias());
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      _errorName =
          _controllerName.text.isEmpty ? 'El nombre es obligatorio' : null;
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

  void _validateCCI() {
    setState(() {
      if (_controllerCCI.text.isEmpty) {
        _errorCCI = 'El CCI es obligatorio';
      } else if (_controllerCCI.text.length != 20) {
        _errorCCI = 'Ingresa un CCI válido';
      } else {
        _errorCCI = null;
      }
    });
  }

  void _validateDNI() {
    setState(() {
      if (_controllerDNI.text.isEmpty) {
        _errorDNI = 'El DNI es obligatorio';
      } else if (_controllerDNI.text.length != 11) {
        _errorDNI = 'Ingresa un DNI válido';
      } else {
        _errorDNI = null;
      }
    });
  }

  void _validateAlias() {
    setState(() {
      if (_controllerAlias.text.isEmpty) {
        _errorAlias = 'El alias es obligatorio';
      } else {
        _errorAlias = null;
      }
    });
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool _validateForm() {
    _validateName();
    _validateEmail();
    _validateCCI();
    _validateDNI();
    _validateAlias();

    return _errorName == null &&
        _errorEmail == null &&
        _errorCCI == null &&
        _errorDNI == null &&
        _errorAlias == null;
  }

  void createUser() async {
    if (_validateForm()) {}
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
                            const Text(
                              'Datos de cuenta bancaria',
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
                                'Por favor, ingresar los datos de la cuenta bancaria para retirar el dinero solicitado',
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
                              hintText: 'Nombre completo (titular)',
                              svgIcon: 'assets/img/name_user.svg',
                              errorText: _errorName,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _controllerEmail,
                              hintText: 'Correo electrónico',
                              svgIcon: 'assets/img/name_user.svg',
                              errorText: _errorEmail,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _controllerCCI,
                              hintText: 'Cuenta interbancaria CCI (20 dígitos)',
                              svgIcon: 'assets/img/name_user.svg',
                              errorText: _errorCCI,
                              maxLength: 20,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _controllerDNI,
                              hintText: 'DNI/RUC',
                              svgIcon: 'assets/img/name_user.svg',
                              errorText: _errorDNI,
                              maxLength: 11,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _controllerAlias,
                              hintText: 'Alias',
                              svgIcon: 'assets/img/name_user.svg',
                              errorText: _errorAlias,
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
    int? maxLength,
    String? errorText,
  }) {
    return Column(
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
                  maxLength: maxLength,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: const Color(0xff141414).withOpacity(0.25),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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
    );
  }
}
