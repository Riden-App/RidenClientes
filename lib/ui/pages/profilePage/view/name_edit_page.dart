import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/user_service.dart';
import 'package:ride_usuario/themes/colors.dart';

import '/utils/button.dart' as btn;

class NameEditPage extends StatefulWidget {
  const NameEditPage({super.key});

  @override
  State<NameEditPage> createState() => _NameEditPageState();
}

class _NameEditPageState extends State<NameEditPage> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final PreferenciasUsuario prefs = PreferenciasUsuario();
  bool nameEmpty = false;
  bool lastNameEmpty = false;

  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    controllerName.text = prefs.firstName;
    controllerLastName.text = prefs.lastName;
  }

  ///
  void sendInfoToEdit() async {
    if (nameEmpty || lastNameEmpty) {
      return;
    }
    final resultUpdateProfile = await userService.updateInfoUser(
        idUser: prefs.idUser,
        name: controllerName.text,
        lastName: controllerLastName.text);
    if (resultUpdateProfile.isSuccess) {
      prefs.saveUserData(
        idUser: prefs.idUser,
        email: prefs.email,
        phoneNumber: prefs.phoneNumber,
        accessToken: prefs.accessToken,
        refreshToken: prefs.refreshToken,
        firstName: controllerName.text,
        lastName: controllerLastName.text,
      );
      Navigator.pushReplacementNamed(context, '/userProfile');
    } else {
      print('Error al guardar los datos ${resultUpdateProfile.error}');
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
                'Nombre',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 43,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Text(
                  'Por favor, ingresa tu nombre real para brindar confianza a los conductores',
                  style: TextStyle(
                    color: AppColors.black60,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
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
                                nameEmpty = true;
                              } else {
                                nameEmpty = false;
                              }
                            });
                          },
                          controller: controllerName,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Nombre',
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
                      SizedBox(
                        width: 32,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
                            'assets/img/last_name_user.svg',
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
                                lastNameEmpty = true;
                              } else {
                                lastNameEmpty = false;
                              }
                            });
                          },
                          controller: controllerLastName,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Apellido',
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
                      SizedBox(
                        width: 32,
                      )
                    ],
                  ),
                ),
              ),
              const Spacer(),
              btn.button(
                  label: 'Guardar',
                  onPressed: sendInfoToEdit,
                  disabled: nameEmpty || lastNameEmpty,
                  type: 'black'),
            ]),
          ),
        ),
      ),
    );
  }
}
