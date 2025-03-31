import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ride_usuario/data/repositories/auth_reposity.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';

part 'google_auth_event.dart';
part 'google_auth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  GoogleAuthBloc(this._authReposity, this.prefs) : super(GoogleAuthInitial()) {
    on<SignInEvent>(_signinWithGoogle);
  }

  final AuthReposity _authReposity;
  final PreferenciasUsuario prefs;

  Future<void> _signinWithGoogle(
      SignInEvent event, Emitter<GoogleAuthState> emit) async {
    emit(GoogleAuthPending());
    try {
      final user = await _authReposity.signInWithGoogle();
      if (user == 1) {
        emit(GoogleAuthSuccess());
      } else if (user == 2) {
        emit(GoogleAuthSuccessRegister());
      } else {
        emit(GoogleAuthError());
      }
    } catch (error) {
      emit(GoogleAuthError());
    }
  }
}
