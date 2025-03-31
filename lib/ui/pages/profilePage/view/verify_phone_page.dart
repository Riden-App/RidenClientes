import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:ride_usuario/services/login_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/user_service.dart';
import 'package:ride_usuario/ui/pages/codePhone/widgets/timer.dart';

class VerifyCodePhoneEditPage extends StatefulWidget {
  const VerifyCodePhoneEditPage(
      {super.key, required this.verificationId, required this.phoneNumber});
  final String verificationId;
  final String phoneNumber;

  @override
  State<VerifyCodePhoneEditPage> createState() =>
      _VerifyCodePhoneEditPageState();
}

final PreferenciasUsuario prefs = PreferenciasUsuario();
final LoginService _loginService = LoginService();

String? _errorMessage;

const fillColor = Color.fromRGBO(243, 246, 249, 0);
final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: const TextStyle(
    fontSize: 22,
    color: Color.fromRGBO(0, 0, 0, 1),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(19),
    border: Border.all(color: Color(0xff0D0D0D)),
  ),
);

class _VerifyCodePhoneEditPageState extends State<VerifyCodePhoneEditPage> {
  UserService userService = UserService();

  Future<void> sendInfoToEdit() async {
    final resultUpdateProfile = await userService.updateInfoUser(
      idUser: prefs.idUser,
      mobile: widget.phoneNumber,
    );
    if (resultUpdateProfile.isSuccess) {
      prefs.saveUserData(
        idUser: prefs.idUser,
        email: prefs.email,
        phoneNumber: widget.phoneNumber,
        accessToken: prefs.accessToken,
        refreshToken: prefs.refreshToken,
        firstName: prefs.firstName,
        lastName: prefs.lastName,
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
                      color: Color(0xff3730F2),
                    ),
                  ),
                ],
              ),
              const Text(
                'Verifica tu número',
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
                    'Por favor, ingresa el código que acabas de recibir',
                    style: TextStyle(
                      color: const Color(0xff2D2D31).withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(height: 45),
              Form(
                child: Column(
                  children: [
                    Pinput(
                      length: 6,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      validator: (value) {
                        if (_errorMessage != null) {
                          return _errorMessage;
                        }
                        return null;
                      },
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) async {
                        try {
                          final credential = PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: pin);

                          final userCredential = await FirebaseAuth.instance
                              .signInWithCredential(credential);

                          if (userCredential.user != null) {
                            setState(() {
                              _errorMessage = null;
                            });

                            await sendInfoToEdit();
                          }
                        } catch (e) {
                          setState(() {
                            _errorMessage = 'Código PIN incorrecto';
                          });
                        }
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 22,
                            height: 1,
                            color: Color(0xff0D0D0D),
                          ),
                        ],
                      ),
                      defaultPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Color(0xff0D0D0D)),
                            color: fillColor),
                      ),
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xff0D0D0D)),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          color: fillColor,
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(color: Color(0xff0D0D0D)),
                        ),
                      ),
                      errorPinTheme: defaultPinTheme.copyBorderWith(
                        border: Border.all(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              const Text(
                'Podrás volver a solicitar un nuevo código en',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              CountdownTimer(),
              const Spacer(
                flex: 2,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
