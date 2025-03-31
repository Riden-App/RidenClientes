part of 'facebook_auth_bloc.dart';

sealed class FacebookAuthEvent extends Equatable {
  const FacebookAuthEvent();

  @override
  List<Object> get props => [];
}

final class SignInFacebookEvent extends FacebookAuthEvent {}
