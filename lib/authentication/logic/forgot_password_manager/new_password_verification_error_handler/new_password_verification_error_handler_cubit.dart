import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'new_password_verification_error_handler_state.dart';

class NewPasswordVerificationErrorHandlerCubit
    extends Cubit<NewPasswordVerificationErrorHandlerState> {
  NewPasswordVerificationErrorHandlerCubit()
      : super(NewPasswordVerificationErrorHandlerInitial());
  Future<void> errorInPassword({required String errorMessage}) async {
    emit(NewPasswordVerificationErrorHandlerInitial());
    emit(ErrorinNewPassword(errorMessage: errorMessage));
  }

  Future<void> errorInOTP() async {
    emit(NewPasswordVerificationErrorHandlerInitial());
    emit(OTPVerificationError());
  }
}
