part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class AnonymousLogin extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final TokenData tokenData;

  LoggedIn({required this.tokenData});

  @override
  String toString() => 'LoggedIn { token: $tokenData}';
}

class VerificationMailSent extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}
