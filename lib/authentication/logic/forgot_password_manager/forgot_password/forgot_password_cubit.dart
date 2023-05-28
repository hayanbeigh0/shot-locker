// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shot_locker/authentication/logic/forgot_password_manager/new_password_verification_error_handler/new_password_verification_error_handler_cubit.dart';
import 'package:shot_locker/authentication/repository/forgot_password_repository.dart';
import 'package:shot_locker/utility/loading_spinner_dialogbox.dart';
import 'package:shot_locker/utility/show_snak_bar.dart';
part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final NewPasswordVerificationErrorHandlerCubit
      newPasswordVerificationErrorHandlerCubit;
  ForgotPasswordCubit({
    required this.newPasswordVerificationErrorHandlerCubit,
  }) : super(OpenEnterEmailWidget());
  String? email;
  final _forgotPasswordRepository = ForgotPasswordRepository();
  void disposeEmail() {
    email = null;
  }

  Future<void> resetScreen() async {
    emit(OpenEnterEmailWidget());
  }

  Future<void> sendForgotPasswordRequest(
    BuildContext context, {
    required String email,
  }) async {
    try {
      this.email = email;
      ShowDialogSpinner.showDialogSpinner(context: context);
      await _forgotPasswordRepository.sendforgotpasswordrequest(
          email: this.email!);
      ShowSnackBar.showSnackBar(context, 'OTP sent to ${this.email}.');
      emit(OpenEnterOTPWidget());
      Navigator.pop(context); //close the spinner
    } catch (e) {
      if (e is DioError) {
        ShowSnackBar.showSnackBar(
          context,
          e.response!.data['message'],
          backGroundColor: Colors.red,
        );
      } else {
        ShowSnackBar.showSnackBar(context, 'Unable to send request.');
      }
      Navigator.pop(context); //close the spinner
    }
  }

  Future<void> passwordVerificationRequest(
    BuildContext context, {
    required String otp,
    required String newpassword,
  }) async {
    try {
      ShowDialogSpinner.showDialogSpinner(context: context);
      await _forgotPasswordRepository.verifyNewPassword(
        email: email ?? '',
        otp: otp,
        newpassword: newpassword,
      );
      ShowSnackBar.showSnackBar(
        context,
        'Password changed successfully. Login to continue.',
      );
      disposeEmail();
      Navigator.pop(context); //Close the dialog spinner
      Navigator.pop(context); //Close the forgot password screen
    } catch (e) {
      if (e is DioError) {
        if (e.response!.data['message'].toString().contains('Invalid OTP')) {
          newPasswordVerificationErrorHandlerCubit.errorInOTP();
        } else {
          ShowSnackBar.showSnackBar(
            context,
            e.response!.data['message'],
            backGroundColor: Colors.red,
          );
        }
      } else {
        ShowSnackBar.showSnackBar(context, 'Unable to change password.');
      }
      Navigator.pop(context); //close the spinner

      return;
    }
  }
}
