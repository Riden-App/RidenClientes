part of 'facebook_auth_bloc.dart';

sealed class FacebookAuthState extends Equatable {
  const FacebookAuthState();

  @override
  List<Object> get props => [];
}

final class FacebookAuthInitial extends FacebookAuthState {}

final class FacebookAuthPending extends FacebookAuthState {}

final class FacebookAuthError extends FacebookAuthState {}

final class FacebookAuthSuccess extends FacebookAuthState {}

final class FacebookAuthSuccessRegister extends FacebookAuthState {}
