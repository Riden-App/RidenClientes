import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/pages/profilePage/view/verify_phone_page.dart';

import '/utils/button.dart' as btn;

class PhoneEditPage extends StatefulWidget {
  const PhoneEditPage({super.key});

  @override
  State<PhoneEditPage> createState() => _PhoneEditPageState();
}

class _PhoneEditPageState extends State<PhoneEditPage> {
  final TextEditingController controllerPhone = TextEditingController();
  final PreferenciasUsuario prefs = PreferenciasUsuario();
  bool phoneEmpty = false;


  void sendNumberCode() {
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+51${controllerPhone.text.trim()}',
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: (error) {
          print('Error: $error');
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          prefs.saveUserData(
            idUser: prefs.idUser,
            email: prefs.email,
            phoneNumber: controllerPhone.text.trim(),
            accessToken: prefs.accessToken,
            refreshToken: prefs.refreshToken,
            firstName: prefs.firstName,
            lastName: prefs.lastName,
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyCodePhoneEditPage(
                        verificationId: verificationId,
                        phoneNumber: controllerPhone.text.trim(),
                      )));
        },
        codeAutoRetrievalTimeout: (verificationId) {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.black03,
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
                    'Ingresa tus datos',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 41,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: Text(
                      'Si cambias tu número de celular, toda la información relacionada a tu cuenta, se transferirá al nuevo número.',
                      style: TextStyle(
                        color: const Color(0xff2D2D31).withOpacity(0.6),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 37.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: AppColors.black10),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '+51',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 21,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onChanged: (value) => setState(() {
                                if (value.isEmpty) {
                                  phoneEmpty = true;
                                } else {
                                  phoneEmpty = false;
                                }
                              }),
                              controller: controllerPhone,
                              keyboardType: TextInputType.number,
                              maxLength: 9,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(9),
                              ],
                              decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: 'Nro de teléfono',
                                hintStyle: TextStyle(
                                  color: AppColors.black25,
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
                  SizedBox(
                    height: 20,
                  ),
                  // Agregar un spacer
                  Expanded(
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: Text(
                      '*Te mandaremos un código de confirmación por sms al nuevo número.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black60,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  btn.button(
                      label: 'Confirmar',
                      onPressed: sendNumberCode,
                      disabled: phoneEmpty,
                      type: 'black'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
