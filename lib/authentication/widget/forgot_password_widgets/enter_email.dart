// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/authentication/logic/forgot_password_manager/forgot_password/forgot_password_cubit.dart';
import 'package:shot_locker/utility/ui_color.dart';

class SendEmailWidget extends StatefulWidget {
  final String availableEmail;
  const SendEmailWidget({
    Key? key,
    this.availableEmail = '',
  }) : super(key: key);

  @override
  State<SendEmailWidget> createState() => _SendEmailWidgetState();
}

class _SendEmailWidgetState extends State<SendEmailWidget> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey();
  final _emailController = TextEditingController();
  @override
  void initState() {
    if (widget.availableEmail.isNotEmpty) {
      _emailController.text = widget.availableEmail;
    }
    super.initState();
  }

  Future<void> sendForgotPasswordRequest() async {
    //to vibrate the phone
    await HapticFeedback.lightImpact();
    //close the softkeyboard when _sumbit() is called
    FocusScope.of(context).unfocus();
    if (!_emailFormKey.currentState!.validate()) {
      // Invalid!
      return;
    } else {
      _emailFormKey.currentState!.save();
      // ignore: use_build_context_synchronously
      context
          .read<ForgotPasswordCubit>()
          .sendForgotPasswordRequest(context, email: _emailController.text);
    }
  }

  sendRequestButton() => OutlinedButton(
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
            fontSize: 14.sp,
            fontFamily: 'Lato',
          )),
        ),
        onPressed: sendForgotPasswordRequest,
        child: const Text('Send Request'),
      );

  email() => Form(
        key: _emailFormKey,
        child: TextFormField(
          controller: _emailController,
          key: const ValueKey('Email'),
          autofillHints: const [AutofillHints.email],
          textInputAction: TextInputAction.done,
          autofocus: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
            hintText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          cursorColor: Colors.white,
          validator: (value) {
            if (value!.isEmpty) {
              return "Field can't be empty";
            } else if (!value.contains('@')) {
              return 'Invalid email!';
            }
            return null;
          },
          onSaved: (value) {
            _emailController.text = value!.trim();
          },
        ),
      );

  @override
  void dispose() {
    _emailController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            email(),
            SizedBox(height: 40.h),
            sendRequestButton(),
          ],
        ),
      );
}
