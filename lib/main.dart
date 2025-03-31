import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ride_usuario/blocs/blocs.dart';
import 'package:ride_usuario/enums/user_enum.dart';
import 'package:ride_usuario/lc.dart';
import 'package:ride_usuario/models/auth_response.dart';
import 'package:ride_usuario/models/user_data.dart';
import 'package:ride_usuario/services/firebase_messaging_service.dart';
import 'package:ride_usuario/services/login_service.dart';
import 'package:ride_usuario/services/referred_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/traffic_service.dart';
import 'package:ride_usuario/ui/pages/detailTrip/detail_trip_page.dart';
import 'package:ride_usuario/ui/pages/generalSettings/general_settings_page.dart';
import 'package:ride_usuario/ui/pages/methodPayment/method_payment_page.dart';
import 'package:ride_usuario/ui/pages/pages.dart';
import 'package:ride_usuario/ui/pages/profilePage/view/delete_account_page.dart';
import 'package:ride_usuario/ui/pages/profilePage/view/email_edit_page.dart';
import 'package:ride_usuario/ui/pages/profilePage/view/motive_delete_account_page.dart';
import 'package:ride_usuario/ui/pages/profilePage/view/name_edit_page.dart';
import 'package:ride_usuario/ui/pages/profilePage/view/phone_edit_page.dart';
import 'package:ride_usuario/ui/pages/record/record_page.dart';
import 'package:ride_usuario/ui/pages/references/references_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
PreferenciasUsuario prefs = PreferenciasUsuario();
LoginService _loginService = LoginService();
ReferredService _referredService = ReferredService();

void main() async {
  await initializeDateFormatting('es');
  WidgetsFlutterBinding.ensureInitialized();
  initalizeDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PreferenciasUsuario().init();
  prefs.lugarFin = '';
  prefs.lugarInicio = '';
  prefs.ltLnFin = '';
  prefs.ltLnInicio = '';
  prefs.paymentMethod = '';

  bool isAuthenticated = await _checkAuthentication();

  runApp(MyApp(isAuthenticated: isAuthenticated));
}

Future<bool> loginAndHandleResponse(UserData dataUser) async {
  print('ingreso aqui');
  try {
    final responseLogin = await _loginService.authLogin(dataUser);
    print('ingreso aqui 2');

    if (responseLogin.statusCode == 201) {
      print('ingreso aqui 3');
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
        print('ingreso aqui 4');
        return true;
      } else {
        print('Error al obtener el código de referencia');
        prefs.idTokenGoogle = '';
        prefs.idTokenFacebook = '';
        print('ingreso aqui 5');
        return false;
      }
    } else {
      prefs.idTokenGoogle = '';
      prefs.idTokenFacebook = '';
      print('ingreso aqui 6');
      return false;
    }
  } catch (e) {
    print('Error en la solicitud: $e');
    print('ingreso aqui 7');
    return false;
  }
}

Future<bool> _checkAuthentication() async {
  String userToken = prefs.tokenFirebase;
  print('tokenFirebase ${prefs.tokenFirebase}');
  bool isAuthenticated = prefs.isAuthenticated;
  print('isAuthenticated ${prefs.isAuthenticated}');
  final pnToken = await FirebaseMessaging.instance.getToken();

  if (isAuthenticated && userToken != '') {
    final current = FirebaseAuth.instance.currentUser;
    if (current != null) {
      final tokenFirebase = await current.getIdToken();
      userToken = tokenFirebase!;
      final user = UserData(
        idToken: userToken,
        pnToken: pnToken!,
        mobile: prefs.phoneNumber,
        role: UserRole.passenger,
        authType: AuthType.mobile,
      );
      bool resultLogin = await loginAndHandleResponse(user);
      return resultLogin;
    }
  }
  return false;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isAuthenticated});
  final bool isAuthenticated;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.initialize(navigatorKey);
    _checkForStoredNotification();
  }

  void _checkForStoredNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notificationData = prefs.getString('notification_data');

    if (notificationData != null) {
      await prefs.remove('notification_data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc()),
        BlocProvider(create: (context) => LocationBloc()),
        BlocProvider(
            create: (context) =>
                MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
        BlocProvider(
            create: (context) => SearchBloc(trafficService: TrafficService()))
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Ride',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Onest',
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: widget.isAuthenticated ? '/home' : '/',
        routes: {
          '/': (BuildContext context) => const StartPage(),
          '/signIn': (BuildContext context) => const SignInPage(),
          '/signUp': (BuildContext context) => const RegisterPage(),
          '/signWithPhone': (BuildContext context) =>
              const PhoneVerificationPage(),
          '/home': (BuildContext context) => const PermissionPage(),
          '/detailTrip': (BuildContext context) => const DetailTripPage(),
          '/record': (BuildContext context) => const RecordPage(),
          '/methodPayment': (BuildContext context) => const MethodPaymentPage(),
          '/generalSettings': (BuildContext context) =>
              const GeneralSettingsPage(),
          '/references': (BuildContext context) => const ReferencesPage(),

          // Edit Profile
          '/userProfile': (BuildContext context) => const UserProfilePage(),
          '/nameEditProfile': (BuildContext context) => const NameEditPage(),
          '/phoneEditProfile': (BuildContext context) => const PhoneEditPage(),
          '/emailEditProfile': (BuildContext context) => const EmailEditPage(),

          '/deleteAccount': (BuildContext context) => const DeleteAccountPage(),
          '/motiveDeleteAccount': (BuildContext context) =>
              const MotiveDeleteAccountPage(),
        },
      ),
    );
  }
}
