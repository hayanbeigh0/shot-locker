part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final BuildContext context;
  final String? userfirstName;
  final String? userlastName;
  final String? countryCode;
  final String? phoneNumber;
  final String userEmail;
  final String password;
  final bool isLogin;

  const LoginButtonPressed({
    this.userfirstName,
    this.userlastName,
    this.countryCode,
    this.phoneNumber,
    required this.context,
    required this.userEmail,
    required this.password,
    required this.isLogin,
  });

  @override
  List<Object> get props => [userEmail, password, isLogin];

  @override
  String toString() =>
      'LoginButtonPressed { username: $userEmail, password: $password }';
}

class ReSignUpButtonPressed extends LoginEvent {
  final BuildContext context;
  final String? userfirstName;
  final String? userlastName;
  final String? countryCode;
  final String? phoneNumber;
  final String userEmail;
  final String password;

  const ReSignUpButtonPressed({
    this.userfirstName,
    this.userlastName,
    this.countryCode,
    this.phoneNumber,
    required this.context,
    required this.userEmail,
    required this.password,
  });

  @override
  List<Object> get props => [userEmail, password];

  @override
  String toString() =>
      'ReSignUpButtonPressed { username: $userEmail, password: $password }';
}
