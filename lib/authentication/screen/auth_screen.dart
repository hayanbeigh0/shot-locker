// ignore_for_file: sort_child_properties_last, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shot_locker/authentication/logic/login/login_bloc.dart';
import 'package:shot_locker/authentication/screen/forgot_password_screen.dart';
import 'package:shot_locker/base/golfer/widgets/terms_of_use.dart';
import 'package:shot_locker/constants/constants.dart';
import 'package:shot_locker/constants/enums.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';
import 'package:shot_locker/utility/loading_indicator.dart';
import 'package:shot_locker/utility/ui_color.dart';
import 'package:http/http.dart' as http;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = '/auth_screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  TextStyle defaultStyle = const TextStyle(color: Colors.grey, fontSize: 12.0);
  TextStyle linkStyle = const TextStyle(color: Colors.blue);
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _userfirstNameController = TextEditingController();
  final _userlastNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _countryCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _phoneNumberController = TextEditingController();
  final double _borderRadius = 10;
  dynamic message = true;

  AuthMode _authMode = AuthMode.login;
  var _showPassword = false;
  var _showConfirmPassword = false;

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

  checkUserAccount(String email) async {
    final response = await http.get(Uri.parse(
        'https://shot-locker.com/api/account/check-user?email=$email'));
    setState(() {
      log('Response : ${response.body}');
      message = jsonDecode(response.body)['message'];
      log('Message : $message');
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userfirstNameController.dispose();
    _userlastNameController.dispose();
    _userEmailController.dispose();
    _passwordController.dispose();
    _countryCodeController.dispose();
    // _phoneNumberController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    //to vibrate the phone
    await HapticFeedback.lightImpact();
    //close the softkeyboard when _sumbit() is called
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    } else {
      _formKey.currentState!.save();

      if (_authMode == AuthMode.login) {
        BlocProvider.of<LoginBloc>(context).add(
          LoginButtonPressed(
            context: context,
            userfirstName: _userfirstNameController.text,
            userlastName: _userlastNameController.text,
            userEmail: _userEmailController.text,
            password: _passwordController.text,
            isLogin: true,
          ),
        );
      } else {
        await checkUserAccount(_userEmailController.text);
        if (message == false) {
          BlocProvider.of<LoginBloc>(context).add(
            ReSignUpButtonPressed(
              context: context,
              userfirstName: _userfirstNameController.text,
              userlastName: _userlastNameController.text,
              countryCode: _countryCodeController.text,
              userEmail: _userEmailController.text,
              password: _passwordController.text,
            ),
          );
        } else {
          BlocProvider.of<LoginBloc>(context).add(
            LoginButtonPressed(
              context: context,
              userfirstName: _userfirstNameController.text,
              userlastName: _userlastNameController.text,
              countryCode: _countryCodeController.text,
              userEmail: _userEmailController.text,
              password: _passwordController.text,
              isLogin: false,
            ),
          );
        }
      }
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
        log('Auth Mode : $_authMode');
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  String? emailErrorMessage;
  String? phoneErrorMessage;

  String? passwordErrorMessage;
  @override
  Widget build(BuildContext context) {
    //final _phoneNumber = TextFormField(
    //  key: const ValueKey('Phone'),
    //  controller: _phoneNumberController,
    //  textInputAction: TextInputAction.next,
    //  autofillHints: const [AutofillHints.telephoneNumber],
    //  decoration: InputDecoration(
    //    hintText: 'Phone number',
    //    errorText: phoneErrorMessage,
    //    contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
    //    border: OutlineInputBorder(
    //      borderRadius: BorderRadius.circular(_borderRadius),
    //    ),
    //  ),
    //  cursorColor: Colors.white,
    //  keyboardType: TextInputType.number,
    //  validator: (value) {
    //    phoneErrorMessage = null;
    //    if (value!.isEmpty) {
    //      return "Field can't be empty.";
    //    } else if (!value.contains(RegExp(r'[0-9]'))) {
    //      return 'Invalid phone number!';
    //    }
    //    return null;
    //  },
    //  onSaved: (value) {
    //    _phoneNumberController.text = value!.trim();
    //  },
    //);

    final _firstName = TextFormField(
      key: const ValueKey('First name'),
      controller: _userfirstNameController,
      autofillHints: const [AutofillHints.name],
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'First name',
        contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
      cursorColor: Colors.white,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value!.isEmpty) {
          return "Field can't be empty.";
        }
        return null;
      },
      onSaved: (value) {
        _userfirstNameController.text = value!.trim();
      },
    );
    final _lastName = TextFormField(
      key: const ValueKey('Last name'),
      controller: _userlastNameController,
      autofillHints: const [AutofillHints.familyName],
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'Last name',
        contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
      cursorColor: Colors.white,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value!.isEmpty) {
          return "Field can't be empty.";
        }
        return null;
      },
      onSaved: (value) {
        _userlastNameController.text = value!.trim();
      },
    );
    final userEmail = TextFormField(
      key: const ValueKey('Email'),
      controller: _userEmailController,
      autofillHints: const [AutofillHints.email],
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'Email',
        errorText: emailErrorMessage,
        contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
      cursorColor: Colors.white,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        emailErrorMessage = null;
        if (value!.isEmpty) {
          return "Field can't be empty";
        } else if (!value.contains('@')) {
          return 'Invalid email!';
        }
        return null;
      },
      onSaved: (value) {
        _userEmailController.text = value!.trim();
      },
    );
    final password = TextFormField(
      key: const ValueKey('Password'),
      autofillHints: const [AutofillHints.password],
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
        hintText: 'Password',
        errorText: passwordErrorMessage,
        suffixIcon: IconButton(
          onPressed: showPassword,
          icon: _showPassword
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
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
        _passwordController.text = value!.trim();
      },
    );
    final confirmPassword = TextFormField(
      key: const ValueKey('Confirm password'),
      enabled: _authMode == AuthMode.signup,
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
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
      cursorColor: Colors.white,
      obscureText: _showConfirmPassword ? false : true,
      validator: _authMode == AuthMode.signup
          ? (value) {
              if (value!.isEmpty) {
                return 'Re-enter your password';
              } else if (value != _passwordController.text) {
                return 'Passwords do not match!';
              } else {
                return null;
              }
            }
          : null,
    );
    final submitButton = OutlinedButton(
      child: Text(_authMode == AuthMode.login ? 'Log in' : 'Sign up'),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
          horizontal: 35.w,
          vertical: 18.h,
        )),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
        ),
        foregroundColor:
            MaterialStateProperty.all(UiColors.logInButtonForeground),
        textStyle: MaterialStateProperty.all(TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
          fontFamily: 'Lato',
        )),
      ),
      onPressed: _submit,
    );
    final authSwtich = TextButton(
      child: Text(
        _authMode == AuthMode.login
            ? 'New user? Sign up here'
            : 'I have already an account',
      ),
      onPressed: _switchAuthMode,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 30.w, vertical: 6.h)),
        textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          fontFamily: 'Lato',
        )),
      ),
    );
    final forgotPassword = TextButton(
      child: const Text('Forgot password?'),
      onPressed: () {
        Navigator.pushNamed(
          context,
          ForgotPasswwordScreen.routeName,
          arguments: _userEmailController.text,
        );
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        padding:
            MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 5.w)),
        textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          fontFamily: 'Lato',
        )),
      ),
    );

    return Scaffold(
      body: ShotLockerBackgroundTheme(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'shotlocker',
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: _authMode == AuthMode.signup ? 60.h : 40.h,
                      ),
                      child: Text(
                        'SHOT LOCKER',
                        style: GoogleFonts.josefinSans(
                          fontSize: 30.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  if (_authMode == AuthMode.signup) _firstName,
                  if (_authMode == AuthMode.signup) SizedBox(height: 20.h),
                  if (_authMode == AuthMode.signup) _lastName,
                  SizedBox(height: 20.h),
                  BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginFailureByEmail) {
                        setState(() {
                          emailErrorMessage = state.rawError;
                          log(emailErrorMessage.toString());
                        });
                      }
                    },
                    child: userEmail,
                  ),
                  // if (_authMode == AuthMode.signup)
                  //   SizedBox(height: _deviceSize.height * 0.02),
                  // if (_authMode == AuthMode.signup)
                  //   BlocListener<LoginBloc, LoginState>(
                  //     listener: (context, state) {
                  //       if (state is LoginFailureByPhone) {
                  //         setState(() {
                  //           phoneErrorMessage = state.rawError;
                  //         });
                  //       }
                  //     },
                  //     child: _phoneNumber,
                  //   ),
                  SizedBox(height: 20.h),
                  BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginFailureByPassword) {
                        setState(() {
                          passwordErrorMessage = state.rawError;
                        });
                      }
                    },
                    child: password,
                  ),
                  SizedBox(height: 20.h),
                  if (_authMode == AuthMode.signup) confirmPassword,
                  if (_authMode == AuthMode.login)
                    Align(
                      alignment: Alignment.centerRight,
                      child: forgotPassword,
                    ),

                  if (_authMode == AuthMode.signup) SizedBox(height: 20.h),
                  SizedBox(height: 10.h),
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginFailure) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Constants.boxBgColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              side: const BorderSide(color: Colors.white),
                            ),
                            title: const Text(
                              'Error while authenticate',
                              style: TextStyle(fontSize: 18),
                            ),
                            content: Text(state.rawError),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return Column(children: [
                          SizedBox(height: 30.h),
                          const LoadingIndicator()
                        ]);
                      } else {
                        return Column(children: [
                          submitButton,
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  _authMode == AuthMode.signup ? 10.h : 20.h,
                            ),
                            child: authSwtich,
                          ),
                          if (_authMode == AuthMode.signup)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: RichText(
                                text: TextSpan(
                                  style: defaultStyle,
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text:
                                          'By clicking Sign Up, you agree to our ',
                                    ),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: linkStyle,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.of(context)
                                            .pushNamed(TermsOfUse.routeName),
                                    ),
                                    // const TextSpan(
                                    //     text: ' and that you have read our '),
                                    // TextSpan(
                                    //     text: 'Privacy Policy',
                                    //     style: linkStyle,
                                    //     recognizer: TapGestureRecognizer()
                                    //       ..onTap = () async {
                                    //         await canLaunch(privacy_policy)
                                    //             ? launch(privacy_policy)
                                    //             : ShowSnackBar.showSnackBar(
                                    //                 context,
                                    //                 'Error occured !',
                                    //                 backGroundColor: Colors.red,
                                    //               );
                                    //       }),
                                  ],
                                ),
                              ),
                            ),
                        ]);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
