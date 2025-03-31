import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/user_service.dart';
import 'package:ride_usuario/themes/colors.dart';

import '/utils/button.dart' as btn;

class VerifyEmailEditPage extends StatefulWidget {
  final String email;
  const VerifyEmailEditPage({super.key, required this.email});

  @override
  State<VerifyEmailEditPage> createState() => _VerifyEmailEditPageState();
}

class _VerifyEmailEditPageState extends State<VerifyEmailEditPage> {
  final TextEditingController controllerName = TextEditingController();
  final PreferenciasUsuario prefs = PreferenciasUsuario();
  UserService userService = UserService();
  bool emailEmpty = false;

  @override
  void initState() {
    controllerName.text = prefs.email;
    super.initState();
  }

  void sendInfoToEdit() async {
    if (emailEmpty) {
      return;
    }
    final resultUpdateProfile = await userService.verifyEmailChange(
      email: widget.email,
      code: controllerName.text.trim(),
    );

    if (resultUpdateProfile.statusCode == 201) {
      print('Email verificado');
      prefs.saveUserData(
        idUser: prefs.idUser,
        email:  widget.email,
        phoneNumber: prefs.phoneNumber,
        accessToken: prefs.accessToken,
        refreshToken: prefs.refreshToken,
        firstName: prefs.firstName,
        lastName: prefs.lastName,
      );
      Navigator.pushReplacementNamed(context, '/userProfile');
    } else {
      print('Error al verificar el email ${resultUpdateProfile.data}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xffF7F7F7).withOpacity(0.8),
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
              const Text(
                'Codigo de verificación',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 41,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    'Verifica tu correo electrónico e ingresa tu código de verificación para continuar.',
                    style: TextStyle(
                      color: AppColors.black60,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  )),
              SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 37.0),
                child: Container(
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
                            'assets/img/name_user.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                emailEmpty = true;
                              } else {
                                emailEmpty = false;
                              }
                            });
                          },
                          controller: controllerName,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Correo',
                            hintStyle: TextStyle(
                              color: const Color(0xff141414).withOpacity(0.25),
                              fontWeight: FontWeight.w600,
                              fontSize: 21,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 21,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(height: 20),
              btn.button(
                  label: 'Enviar código',
                  onPressed: sendInfoToEdit,
                  disabled: emailEmpty,
                  type: 'black'),
            ]),
          ),
        ),
      ),
    );
  }
}
