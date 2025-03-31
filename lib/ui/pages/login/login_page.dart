import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ride_usuario/data/repositories/auth_reposity.dart';
import 'package:ride_usuario/enums/user_enum.dart';
import 'package:ride_usuario/models/auth_response.dart';
import 'package:ride_usuario/models/user_data.dart';
import 'package:ride_usuario/services/login_service.dart';
import 'package:ride_usuario/services/referred_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/ui/pages/login/blocs/facebook_auth/facebook_auth_bloc.dart';
import 'package:ride_usuario/ui/pages/login/blocs/google_auth/google_auth_bloc.dart';

import '/utils/button.dart' as btn;

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});
  @override
  Widget build(BuildContext context) {
    final authReposity = GetIt.instance<AuthReposity>();
    final preferences = GetIt.instance<PreferenciasUsuario>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GoogleAuthBloc(authReposity, preferences),
        ),
        BlocProvider(
          create: (context) => FacebookAuthBloc(authReposity, preferences),
        ),
      ],
      child: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final PreferenciasUsuario prefs = PreferenciasUsuario();
  final LoginService _loginService = LoginService();
  final ReferredService _referredService = ReferredService();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  Future<void> loginAndHandleResponse(
      UserData dataUser, BuildContext context) async {
    try {
      final responseLogin = await _loginService.authLogin(dataUser);

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

        final responseCodeReferred = await _referredService
            .getDetailReferredByUser(authResponse.data.user.id.toString());

        if (responseCodeReferred.isSuccess) {
          prefs.referralCode = responseCodeReferred.data!.data.code;
          prefs.idTokenGoogle = '';
          prefs.idTokenFacebook = '';
          prefs.isAuthenticated = true;
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          print('Error al obtener el código de referencia');
          prefs.idTokenGoogle = '';
          prefs.idTokenFacebook = '';
          Navigator.pushReplacementNamed(context, '/');
        }
      } else {
        prefs.idTokenGoogle = '';
        prefs.idTokenFacebook = '';
        Navigator.pushReplacementNamed(context, '/');
        print('Error: Código de estado es ${responseLogin.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 327,
                color: Colors.black,
              ),
              Positioned.fill(
                child: Align(
                  child: Image.asset(
                    'assets/img/logo_login.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          const Text(
            'Continua con:',
            style: TextStyle(
              color: Color(0xff0D0D0D),
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 52.0),
            child: Column(
              children: [
                btn.gradientButton(
                  label: 'Nro. telefónico',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signWithPhone');
                  },
                  icon: Image.asset('assets/img/phone.png'),
                ),
                const SizedBox(height: 12),
                BlocListener<GoogleAuthBloc, GoogleAuthState>(
                  listener: (context, state) async {
                    if (state is GoogleAuthSuccess) {
                      final pnToken =
                          await FirebaseMessaging.instance.getToken();
                      final dataUser = UserData(
                        idToken: prefs.idTokenGoogle,
                        pnToken: pnToken!,
                        mobile: prefs.phoneNumberGoogleFacebook,
                        role: UserRole.passenger,
                        authType: AuthType.mobile,
                      );

                      await loginAndHandleResponse(dataUser, context);
                    } else if (state is GoogleAuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error de autenticación'),
                        ),
                      );
                    } else if (state is GoogleAuthSuccessRegister) {
                      Navigator.pushReplacementNamed(context, '/signWithPhone');
                    }
                  },
                  child: btn.buttonWhitIcon(
                    label: 'Google',
                    onPressed: () =>
                        context.read<GoogleAuthBloc>().add(SignInEvent()),
                    icon: SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset(
                        'assets/img/google.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                BlocListener<FacebookAuthBloc, FacebookAuthState>(
                  listener: (context, state) async {
                    if (state is FacebookAuthSuccess) {
                      final pnToken =
                          await FirebaseMessaging.instance.getToken();
                      final dataUser = UserData(
                        idToken: prefs.idTokenFacebook,
                        pnToken: pnToken!,
                        mobile: prefs.phoneNumberGoogleFacebook,
                        role: UserRole.passenger,
                        authType: AuthType.mobile,
                      );

                      await loginAndHandleResponse(dataUser, context);
                    } else if (state is FacebookAuthSuccessRegister) {
                      Navigator.pushReplacementNamed(context, '/signWithPhone');
                    } else if (state is FacebookAuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error de autenticación'),
                        ),
                      );
                    }
                  },
                  child: btn.buttonWhitIcon(
                    label: 'Facebook',
                    onPressed: () => context
                        .read<FacebookAuthBloc>()
                        .add(SignInFacebookEvent()),
                    icon: SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset(
                        'assets/img/facebook.png',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(
            flex: 2,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            width: double.infinity,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: '¿Eres conductor? ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff0D0D0D),
                    ),
                  ),
                  TextSpan(
                    text: 'Ir al app',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff0077FF),
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 31),
        ],
      ),
    );
  }
}
