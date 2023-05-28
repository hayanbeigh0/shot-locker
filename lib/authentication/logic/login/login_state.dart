part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}


class LoginFailure extends LoginState {
  final String rawError;
  const LoginFailure({required this.rawError});

  @override
  List<Object> get props => [rawError];
}

class LoginFailureByEmail extends LoginState {
  final String rawError;
  const LoginFailureByEmail({required this.rawError});

  @override
  List<Object> get props => [rawError];
}
class LoginFailureByPassword extends LoginState {
  final String rawError;
  const LoginFailureByPassword({required this.rawError});

  @override
  List<Object> get props => [rawError];
}

class LoginFailureByPhone extends LoginState {
  final String rawError;
  const LoginFailureByPhone({required this.rawError});

  @override
  List<Object> get props => [rawError];
}
