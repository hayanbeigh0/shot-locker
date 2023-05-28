// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shot_locker/authentication/logic/authentication/authentication_bloc.dart';
import 'package:shot_locker/authentication/model/auth_model.dart';
import 'package:shot_locker/authentication/repository/auth_repository.dart';
import 'package:shot_locker/utility/show_snak_bar.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;

  LoginBloc({required this.authenticationBloc}) : super(LoginInitial()) {
    on<LoginEvent>(
      (event, emit) async {
        final userRepository = AuthenticationRepository();
        if (event is LoginButtonPressed) {
          emit(LoginLoading());
          try {
            final response = await userRepository.authenticate(
              userfirstName: event.userfirstName,
              userlastName: event.userlastName,
              userEmail: event.userEmail,
              // phoneNumber: event.phoneNumber,
              password: event.password,
              isLogin: event.isLogin,
            );
            log('Old API Response : $response');
            if (!event.isLogin &&
                response.data['detail']
                    .toString()
                    .contains('Verification e-mail sent.')) {
              ShowSnackBar.showSnackBar(event.context,
                  'Verification link sent to your mail: ${event.userEmail}');
              authenticationBloc.add(VerificationMailSent());
            } else {
              authenticationBloc.add(
                LoggedIn(
                  tokenData: TokenData(token: response.data['access_token']),
                ),
              );
            }
            emit(LoginInitial());
            return;
          } catch (error) {
            if (error is DioError) {
              if (error.response?.data['phone'] != null ||
                  error.response?.data['email'] != null ||
                  error.response?.data['password1'] != null) {
                if (error.response?.data['password1'] != null) {
                  emit(
                    LoginFailureByPassword(
                      rawError: error.response?.data['password1'][0],
                    ),
                  );
                }
                if (error.response?.data['phone'] != null) {
                  emit(
                    LoginFailureByPhone(
                      rawError: error.response?.data['phone'][0],
                    ),
                  );
                }
                if (error.response?.data['email'] != null) {
                  emit(
                    LoginFailureByEmail(
                      rawError: error.response?.data['email'][0],
                    ),
                  );
                }
                return;
              } else if (error.response!.data['non_field_errors'] != null) {
                emit(
                  LoginFailure(
                    rawError: error.response!.data['non_field_errors'][0],
                  ),
                );
                return;
              } else {
                emit(
                  const LoginFailure(rawError: 'Unable to authenticate'),
                );
                return;
              }
            } else {
              emit(
                const LoginFailure(rawError: 'Something went wrong'),
              );
            }
          }
        } else if (event is ReSignUpButtonPressed) {
          emit(LoginLoading());
          try {
            final response = await userRepository.reauthenticate(
              userfirstName: event.userfirstName,
              userlastName: event.userlastName,
              userEmail: event.userEmail,
              password: event.password,
            );
            log('New API Response : $response');
            final emailResponse = await userRepository.reSendEmailVerfication(
              userEmail: event.userEmail,
            );
            log('Email response = $emailResponse');
            if (emailResponse.data['detail'] == 'ok') {
              ShowSnackBar.showSnackBar(event.context,
                  'Verification link sent to your mail: ${event.userEmail}');
              authenticationBloc.add(VerificationMailSent());
            } else {
              authenticationBloc.add(
                LoggedIn(
                  tokenData: TokenData(token: response.data['access_token']),
                ),
              );
            }
            emit(LoginInitial());
            return;
          } catch (error) {
            if (error is DioError) {
              if (error.response?.data['phone'] != null ||
                  error.response?.data['email'] != null ||
                  error.response?.data['password1'] != null) {
                if (error.response?.data['password1'] != null) {
                  emit(
                    LoginFailureByPassword(
                      rawError: error.response?.data['password1'][0],
                    ),
                  );
                }
                if (error.response?.data['phone'] != null) {
                  emit(
                    LoginFailureByPhone(
                      rawError: error.response?.data['phone'][0],
                    ),
                  );
                }
                if (error.response?.data['email'] != null) {
                  emit(
                    LoginFailureByEmail(
                      rawError: error.response?.data['email'][0],
                    ),
                  );
                }
                return;
              } else if (error.response!.data['non_field_errors'] != null) {
                emit(
                  LoginFailure(
                    rawError: error.response!.data['non_field_errors'][0],
                  ),
                );
                return;
              } else {
                emit(
                  const LoginFailure(rawError: 'Unable to authenticate'),
                );
                return;
              }
            } else {
              emit(
                const LoginFailure(rawError: 'Something went wrong'),
              );
            }
          }
        }
      },
    );
  }
}
