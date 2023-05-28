// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shot_locker/authentication/logic/forgot_password_manager/forgot_password/forgot_password_cubit.dart';
import 'package:shot_locker/authentication/logic/forgot_password_manager/new_password_verification_error_handler/new_password_verification_error_handler_cubit.dart';
import 'package:shot_locker/authentication/widget/divider_with_text.dart';
import 'package:shot_locker/utility/ui_color.dart';

class EnterOTPWidget extends StatefulWidget {
  const EnterOTPWidget({Key? key}) : super(key: key);

  @override
  State<EnterOTPWidget> createState() => _EnterOTPWidgetState();
}

class _EnterOTPWidgetState extends State<EnterOTPWidget> {
  final GlobalKey<FormState> _passwordFormKey = GlobalKey();
  var _showPassword = false;
  var _showConfirmPassword = false;
  final _newpasswordController = TextEditingController();
  final _otpController = TextEditingController();
  int otplength = 6;
  final double _borderRadius = 10;
  late StreamController<ErrorAnimationType> _otperrorController;

  String? otpErrorMessage;
  String? passwordErrorMessage;
  @override
  void dispose() {
    _newpasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _otperrorController = StreamController<ErrorAnimationType>();

    super.initState();
  }

  Future<void> sendPasswordVerificationRequest() async {
    //to vibrate the phone
    await HapticFeedback.lightImpact();
    //close the softkeyboard when _sumbit() is called
    FocusScope.of(context).unfocus();
    if (!_passwordFormKey.currentState!.validate() ||
        _otpController.text.length < otplength) {
      // Invalid!
      if (_otpController.text.length < otplength) {
        await HapticFeedback.vibrate();
        _otpValidationError();
      }
      return;
    } else {
      _passwordFormKey.currentState!.save();
      context.read<ForgotPasswordCubit>().passwordVerificationRequest(
            context,
            otp: _otpController.text,
            newpassword: _newpasswordController.text,
          );
    }
  }

  submitButton() => OutlinedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            horizontal: 35.w,
            vertical: 18.h,
          )),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          foregroundColor:
              MaterialStateProperty.all(UiColors.logInButtonForeground),
          textStyle: MaterialStateProperty.all(TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            fontFamily: 'Lato',
          )),
        ),
        onPressed: sendPasswordVerificationRequest,
        child: const Text('Submit'),
      );

  bool showPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
    return _showPassword;
  }

  bool showConfirmPassword() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
    return _showConfirmPassword;
  }

  newpassword() => TextFormField(
        key: const ValueKey('Newassword'),
        autofillHints: const [AutofillHints.password],
        textInputAction: TextInputAction.next,
        controller: _newpasswordController,
        autofocus: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
          hintText: 'New Password',
          errorText: passwordErrorMessage,
          suffixIcon: IconButton(
            onPressed: showPassword,
            icon: _showPassword
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius.r),
          ),
        ),
        cursorColor: Colors.white,
        //it is used to hide the character during password entry.
        obscureText: _showPassword ? false : true,
        validator: (value) {
          passwordErrorMessage = null;

          if (value!.isEmpty) {
            return "Field can't be empty";
          } else {
            return null;
          }
        },
        onSaved: (value) {
          _newpasswordController.text = value!.trim();
        },
      );

  confirmPassword() => TextFormField(
        key: const ValueKey('Confirm password'),
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: 'Confirm password',
          contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
          suffixIcon: IconButton(
            onPressed: showConfirmPassword,
            icon: _showConfirmPassword
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius.r),
          ),
        ),
        cursorColor: Colors.white,
        obscureText: _showConfirmPassword ? false : true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Re-enter your password';
          } else if (value != _newpasswordController.text) {
            return 'Passwords do not match!';
          } else {
            return null;
          }
        },
      );

  Future<void> _otpValidationError() async {
    _otperrorController.add(ErrorAnimationType.shake);
    // Triggering error shake animation
    return;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocListener<NewPasswordVerificationErrorHandlerCubit,
            NewPasswordVerificationErrorHandlerState>(
          listener: (context, state) {
            if (state is ErrorinNewPassword) {
              setState(() {
                passwordErrorMessage = state.errorMessage;
              });
            }
            if (state is OTPVerificationError) {
              _otpValidationError();
            }
          },
          child: Form(
            key: _passwordFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: const DividerWithText(text: 'Enter OTP'),
                ),
                OTPField(
                  valuekey: 'EmailOTP',
                  otpLength: otplength,
                  errorController: _otperrorController,
                  onCompleted: (value) {
                    _otpController.text = value.trim();
                  },
                  onSaved: (value) {},
                  onChanged: (value) {},
                  beforeTextPaste: (text) {
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    HapticFeedback.lightImpact();
                    return true;
                  },
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: const DividerWithText(text: 'Set new password'),
                ),
                SizedBox(height: 10.h),
                newpassword(),
                SizedBox(height: 10.h),
                confirmPassword(),
                SizedBox(height: 20.h),
                submitButton(),
              ],
            ),
          ),
        ),
      );
}

class OTPField extends StatelessWidget {
  final String valuekey;
  final int otpLength;
  final StreamController<ErrorAnimationType>? errorController;
  final void Function(String)? onCompleted;
  final void Function(String?)? onSaved;
  final void Function(String) onChanged;
  final bool Function(String?)? beforeTextPaste;
  const OTPField({
    Key? key,
    required this.valuekey,
    required this.otpLength,
    required this.errorController,
    required this.onCompleted,
    required this.onSaved,
    required this.onChanged,
    required this.beforeTextPaste,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
      ),
      child: PinCodeTextField(
          key: ValueKey(valuekey),
          appContext: context,
          length: otpLength,
          obscureText: true,
          enableActiveFill: true,
          blinkWhenObscuring: true,
          // cursorColor: LoginScreenColor.otpColor,
          animationDuration: const Duration(milliseconds: 300),
          errorAnimationController: errorController,
          keyboardType: TextInputType.number,
          pastedTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          useHapticFeedback: true,
          enablePinAutofill: true,
          animationType: AnimationType.fade,
          cursorColor: Colors.black,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5.r),
            fieldHeight: 50.h,
            fieldWidth: 50.w,
            activeColor: Colors.white,
            activeFillColor: Colors.black,
            inactiveColor: Theme.of(context).primaryColor,
            inactiveFillColor: Colors.black38,
            selectedFillColor: Colors.transparent,
            selectedColor: Colors.white,
          ),
          // textStyle: TextStyle(color: LoginScreenColor.otpColor),
          boxShadows: const [
            BoxShadow(
              offset: Offset(0, 0),
              color: Colors.grey,
              blurRadius: 0,
            )
          ],
          onCompleted: onCompleted,
          onSaved: onSaved,
          onChanged: onChanged,
          beforeTextPaste: beforeTextPaste
          //  (text) {
          //   //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //   //but you can show anything you want here, like your pop up saying wrong paste format or etc
          //   HapticFeedback.lightImpact();
          //   return true;
          // },
          ),
    );
  }
}
