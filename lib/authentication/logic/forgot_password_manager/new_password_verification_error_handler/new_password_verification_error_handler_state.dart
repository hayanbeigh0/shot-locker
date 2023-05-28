// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'new_password_verification_error_handler_cubit.dart';

abstract class NewPasswordVerificationErrorHandlerState extends Equatable {
  const NewPasswordVerificationErrorHandlerState();

  @override
  List<Object> get props => [];
}

class NewPasswordVerificationErrorHandlerInitial
    extends NewPasswordVerificationErrorHandlerState {}

class OTPVerificationError extends NewPasswordVerificationErrorHandlerState {}

class ErrorinNewPassword extends NewPasswordVerificationErrorHandlerState {
  final String errorMessage;
  const ErrorinNewPassword({
    required this.errorMessage,
  });
}
