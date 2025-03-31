import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_usuario/ui/pages/codePhone/code_verification_page.dart';
import 'package:ride_usuario/ui/pages/profilePage/view/verify_phone_page.dart';

import '/utils/button.dart' as btn;

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({super.key});

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  bool disabledBtn = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  final TextEditingController _controller = TextEditingController();

  void sendNumberCode() {
    prefs.saveUserData(
      idUser: prefs.idUser,
      email: prefs.email,
      phoneNumber: _controller.text.trim(),
      accessToken: prefs.accessToken,
      refreshToken: prefs.refreshToken,
      firstName: prefs.firstName,
      lastName: prefs.lastName,
    );
    print('phoneNumber: ${_controller.text.trim()}');
    int? resendToken;
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+51${_controller.text.trim()}',
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
        print('verificationCompleted: ${phoneAuthCredential.smsCode}');
      },
      verificationFailed: (error) {
        print('error enviar sms: ${error.message}');
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CodePhoneVerificationPage(verificationId: verificationId)));
      },
      forceResendingToken: resendToken,
      codeAutoRetrievalTimeout: (verificationId) {},
    );

    print('resendToken: $resendToken');
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
                      Navigator.pushReplacementNamed(context, '/signIn');
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xff3730F2),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 37,
              ),
              const Text(
                'Ingresa tu número ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 11,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    'Te mandaremos un código de ver ificación por sms',
                    style: TextStyle(
                      color: const Color(0xff2D2D31).withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 53.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.2),
                    ),
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
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          maxLength: 9,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(9),
                          ],
                          onChanged: (value) {
                            setState(() {
                              if (value.length == 9) {
                                disabledBtn = false;
                              } else {
                                disabledBtn = true;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Nro de teléfono',
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
              btn.button(
                  label: 'Enviar código',
                  onPressed: sendNumberCode,
                  type: 'black',
                  disabled: disabledBtn),
            ]),
          ),
        ),
      ),
    );
  }
}
