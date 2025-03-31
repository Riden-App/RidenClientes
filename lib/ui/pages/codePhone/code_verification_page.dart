import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/enums/user_enum.dart';
import 'package:ride_usuario/models/auth_response.dart';
import 'package:ride_usuario/models/models.dart';
import 'package:ride_usuario/services/services.dart';
import 'package:ride_usuario/ui/pages/codePhone/widgets/timer.dart';
import 'package:ride_usuario/ui/pages/profilePage/view/verify_phone_page.dart';

class CodePhoneVerificationPage extends StatefulWidget {
  const CodePhoneVerificationPage({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<CodePhoneVerificationPage> createState() =>
      _CodePhoneVerificationPageState();
}

final PreferenciasUsuario _prefs = PreferenciasUsuario();
final LoginService _loginService = LoginService();
final ReferredService _referredService = ReferredService();

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

class _CodePhoneVerificationPageState extends State<CodePhoneVerificationPage> {
  Future<void> loginAndHandleResponse(
      UserData dataUser, BuildContext context) async {
    try {
      final responseLogin = await _loginService.authLogin(dataUser);

      if (responseLogin.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(responseLogin.data);
        _prefs.saveUserData(
          idUser: authResponse.data.user.id.toString(),
          email: authResponse.data.user.email,
          firstName: authResponse.data.user.firstName,
          lastName: authResponse.data.user.lastName,
          phoneNumber: authResponse.data.user.mobile,
          accessToken: authResponse.data.accessToken,
          refreshToken: authResponse.data.refreshToken,
        );

        final responseCodeReferred = await _referredService
            .getDetailReferredByUser(authResponse.data.user.id.toString());

        if (responseCodeReferred.isSuccess) {
          prefs.referralCode = responseCodeReferred.data!.data.code;
          _prefs.idTokenGoogle = '';
          prefs.idTokenFacebook = '';
          _prefs.isAuthenticated = true;
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          print('Error al obtener el código de referencia');
          prefs.idTokenGoogle = '';
          prefs.idTokenFacebook = '';
          Navigator.pushReplacementNamed(context, '/');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/');
        prefs.idTokenGoogle = '';
        prefs.idTokenFacebook = '';
        print('Error: Código de estado no es 201');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
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
                          final phoneCredential = PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: pin);

                          final phoneUserCredential = await FirebaseAuth
                              .instance
                              .signInWithCredential(phoneCredential);

                          if (phoneUserCredential.user != null) {
                            setState(() {
                              _errorMessage = null;
                            });

                            final phoneNumber =
                                phoneUserCredential.user!.phoneNumber;

                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            final pnToken =
                                await FirebaseMessaging.instance.getToken();
                            prefs.fcmToken = pnToken!;

                            if (currentUser != null &&
                                (prefs.idTokenGoogle != '' ||
                                    prefs.idTokenFacebook != '')) {
                              final OAuthCredential userToLink;

                              if (prefs.idTokenGoogle != '') {
                                userToLink = GoogleAuthProvider.credential(
                                  idToken: prefs.idTokenGoogle,
                                  accessToken: prefs.accessTokenGoogle,
                                );
                              } else if (prefs.idTokenFacebook != '') {
                                userToLink = FacebookAuthProvider.credential(
                                    prefs.idTokenFacebook);
                              } else {
                                throw Exception('Token no encontrado');
                              }

                              await currentUser.linkWithCredential(userToLink);

                              final unifiedToken =
                                  await currentUser.getIdToken();

                              _prefs.tokenFirebase = unifiedToken!;
                              final responseVerify =
                                  await _loginService.verifyUser(unifiedToken);
                              if (responseVerify.statusCode == 200) {
                                final dataUser = UserData(
                                  idToken: unifiedToken,
                                  pnToken: pnToken,
                                  mobile: phoneNumber!,
                                  role: UserRole.passenger,
                                  authType: AuthType.mobile,
                                );

                                _prefs.fcmToken = pnToken;
                                await loginAndHandleResponse(dataUser, context);
                              } else {
                                Navigator.pushReplacementNamed(
                                    context, '/signUp');
                              }
                            } else {
                              final phoneUser =
                                  FirebaseAuth.instance.currentUser;
                              final idTokenPhone =
                                  await phoneUser!.getIdToken();
                              _prefs.tokenFirebase = idTokenPhone!;

                              final responseVerify =
                                  await _loginService.verifyUser(idTokenPhone);
                              if (responseVerify.statusCode == 200) {
                                final dataUser = UserData(
                                  idToken: idTokenPhone,
                                  pnToken: pnToken,
                                  mobile: phoneNumber!,
                                  role: UserRole.passenger,
                                  authType: AuthType.mobile,
                                );

                                _prefs.fcmToken = pnToken;
                                await loginAndHandleResponse(dataUser, context);
                              } else {
                                Navigator.pushReplacementNamed(
                                    context, '/signUp');
                              }
                            }
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
