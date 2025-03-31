import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ride_usuario/data/repositories/auth_reposity.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';

part 'facebook_auth_event.dart';
part 'facebook_auth_state.dart';

class FacebookAuthBloc extends Bloc<FacebookAuthEvent, FacebookAuthState> {
  FacebookAuthBloc(this._authReposity, this._prefs)
      : super(FacebookAuthInitial()) {
    on<SignInFacebookEvent>(_signinWithFacebook);
  }

  final AuthReposity _authReposity;
  final PreferenciasUsuario _prefs;

  Future<void> _signinWithFacebook(
      SignInFacebookEvent event, Emitter<FacebookAuthState> emit) async {
    emit(FacebookAuthPending());
    try {
      final user = await _authReposity.signInWithFacebook();

      if (user == 1) {
        emit(FacebookAuthSuccess());
      } else if (user == 2) {
        emit(FacebookAuthSuccessRegister());
      } else {
        emit(FacebookAuthError());
      }
    } catch (error) {
      emit(FacebookAuthError());
    }
  }
}
