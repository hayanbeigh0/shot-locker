part of 'forgot_password_cubit.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class OpenEnterEmailWidget extends ForgotPasswordState {}

class OpenEnterOTPWidget extends ForgotPasswordState {}
