part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticatedAnonymously extends AuthenticationState {}

class VerifyEmail extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {
  const AuthenticationUnauthenticated();
}

class AuthenticationLoading extends AuthenticationState {}
