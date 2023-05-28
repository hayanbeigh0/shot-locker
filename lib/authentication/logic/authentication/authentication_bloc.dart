import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shot_locker/authentication/model/auth_model.dart';
import 'package:shot_locker/config/token_shared_pref.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  bool isLogoutClicked = false;

  AuthenticationBloc() : super(AuthenticationUninitialized()) {
    final tokenHandler = TokenSharedPref();

    on<AuthenticationEvent>(
      (event, emit) async {
        if (event is AppStarted) {
          await tokenHandler.hasToken().then((value) async {
            if (value) {
              emit(AuthenticationAuthenticated());
            } else {
              emit(const AuthenticationUnauthenticated());
            }
          });
        } else if (event is LoggedIn) {
          emit(AuthenticationLoading());
          await tokenHandler
              .storeToken(event.tokenData)
              .then((value) => emit(AuthenticationAuthenticated()));
        } else if (event is LoggedOut) {
          isLogoutClicked = true;
          emit(AuthenticationLoading());
          await tokenHandler
              .deleteToken()
              .whenComplete(() => emit(const AuthenticationUnauthenticated()));
        } else if (event is VerificationMailSent) {
          //Open Login section
          emit(AuthenticationLoading());
          await Future.delayed(const Duration(seconds: 1));
          log('Testing');
          emit(const AuthenticationUnauthenticated());
        } else if (event is AnonymousLogin) {
          emit(AuthenticationLoading());
          emit(AuthenticatedAnonymously());
        }
      },
    );
  }
}
