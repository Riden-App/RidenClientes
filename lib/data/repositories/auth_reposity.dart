import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ride_usuario/services/login_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';

class AuthReposity {
  final _firebaseAuth = FirebaseAuth.instance;
  final PreferenciasUsuario prefs = PreferenciasUsuario();
  final LoginService _loginService = LoginService();

  Future<int> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return 0;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        return 0;
      }

      prefs.idTokenGoogle = googleAuth.idToken!;
      prefs.accessTokenGoogle = googleAuth.accessToken!;

      await _firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ),
      );

      final current = FirebaseAuth.instance.currentUser;

      if (current != null) {
        final tokenFirebase = await current.getIdToken();
        prefs.idTokenFacebook = '';

        final responseVerify =
            await _loginService.verifyUserFirebase(tokenFirebase!);
        bool isVerify = false;
        if (responseVerify.statusCode == 200) {
          final userData = responseVerify.data['users'][0];
          for (var provider in userData['providerUserInfo']) {
            if (provider['providerId'] == 'phone') {
              isVerify = true;
            }
          }
          if (isVerify) {
            final phoneNumber = userData['phoneNumber'];
            prefs.phoneNumberGoogleFacebook = phoneNumber;
            prefs.idTokenGoogle = tokenFirebase;

            return 1;
          } else {
            await current.delete();
            return 2;
          }
        } else {
          await current.delete();
        }
      }
      return 0;
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      return 0;
    }
  }

  Future<int?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['public_profile'],
    );

    if (result.status == LoginStatus.success) {
      prefs.idTokenFacebook = result.accessToken!.tokenString;
      prefs.idTokenGoogle = '';
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);
      await FirebaseAuth.instance.signInWithCredential(credential);
      final current = FirebaseAuth.instance.currentUser;

      if (current != null) {
        final tokenFirebase = await current.getIdToken();

        final responseVerify =
            await _loginService.verifyUserFirebase(tokenFirebase!);
        bool isVerify = false;
        if (responseVerify.statusCode == 200) {
          final userData = responseVerify.data['users'][0];
          for (var provider in userData['providerUserInfo']) {
            if (provider['providerId'] == 'phone') {
              isVerify = true;
            }
          }
          if (isVerify) {
            final phoneNumber = userData['phoneNumber'];
            prefs.phoneNumberGoogleFacebook = phoneNumber;
            prefs.idTokenFacebook = tokenFirebase;

            return 1;
          } else {
            await current.delete();
            return 2;
          }
        } else {
          await current.delete();
        }
      }
    }

    return 0;
  }
}
