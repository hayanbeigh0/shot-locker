import 'package:dio/dio.dart';
import 'package:shot_locker/config/api_manager.dart';
import 'package:shot_locker/constants/enums.dart';

class AuthenticationRepository {
  final _dio = Dio();
  Future<Response<dynamic>> authenticate({
    String? userfirstName,
    String? userlastName,
    String? phoneNumber,
    required String userEmail,
    required String password,
    required bool isLogin,
  }) async {
    try {
      if (isLogin) {
        var loginBody = {
          'email': userEmail,
          'password': password,
        };
        return await _dio.post(ApiManager.apiManager(UrlType.login),
            data: loginBody);
      } else {
        var signUpBody = {
          'first_name': userfirstName,
          'last_name': userlastName,
          'email': userEmail,
          // 'phone': phoneNumber,
          'password1': password,
          'password2': password,
        };
        return await _dio.post(ApiManager.apiManager(UrlType.signup),
            data: signUpBody);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Response<dynamic>> reauthenticate({
    String? userfirstName,
    String? userlastName,
    String? phoneNumber,
    String? userEmail,
    String? password,
  }) async {
    try {
      var signUpBody = {
        'first_name': userfirstName,
        'last_name': userlastName,
        'email': userEmail,
        'password1': password,
        'password2': password,
      };

      return await _dio.post(
        ApiManager.apiManager(UrlType.resignup),
        data: signUpBody,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<Response<dynamic>> reSendEmailVerfication({
    String? userEmail,
  }) async {
    try {
      var email = {
        'email': userEmail,
      };

      return await _dio.post(
        ApiManager.apiManager(UrlType.resendemailverification),
        data: email,
      );
    } catch (error) {
      rethrow;
    }
  }
}
