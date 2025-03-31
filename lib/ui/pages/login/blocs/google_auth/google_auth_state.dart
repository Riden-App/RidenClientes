part of 'google_auth_bloc.dart';

sealed class GoogleAuthState extends Equatable {
  const GoogleAuthState();

  @override
  List<Object> get props => [];
}

final class GoogleAuthInitial extends GoogleAuthState {}

final class GoogleAuthPending extends GoogleAuthState {}

final class GoogleAuthError extends GoogleAuthState {}

final class GoogleAuthSuccess extends GoogleAuthState {}

final class GoogleAuthSuccessRegister extends GoogleAuthState {}
