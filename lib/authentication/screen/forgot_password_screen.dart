// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shot_locker/authentication/logic/forgot_password_manager/forgot_password/forgot_password_cubit.dart';
import 'package:shot_locker/authentication/widget/forgot_password_widgets/enter_email.dart';
import 'package:shot_locker/authentication/widget/forgot_password_widgets/enter_otp.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';

class ForgotPasswwordScreen extends StatefulWidget {
  const ForgotPasswwordScreen({Key? key}) : super(key: key);
  static const routeName = '/Forgot Password';

  @override
  State<ForgotPasswwordScreen> createState() => _ForgotPasswwordScreenState();
}

class _ForgotPasswwordScreenState extends State<ForgotPasswwordScreen> {
  @override
  void initState() {
    context.read<ForgotPasswordCubit>().resetScreen();
    super.initState();
  }

  String _availableEmail = '';
  @override
  Widget build(BuildContext context) {
    _availableEmail = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Forgot Password'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: ShotLockerBackgroundTheme(
        child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
          builder: (context, state) {
            if (state is OpenEnterOTPWidget) {
              return const EnterOTPWidget();
            } else {
              return SendEmailWidget(
                availableEmail: _availableEmail,
              );
            }
          },
        ),
      ),
    );
  }
}
