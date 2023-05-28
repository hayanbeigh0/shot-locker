import 'package:dio/dio.dart';
import 'package:shot_locker/config/api_manager.dart';
import 'package:shot_locker/constants/enums.dart';

class ForgotPasswordRepository {
  final _dio = Dio();
  Future<void> sendforgotpasswordrequest({
    required String email,
  }) async {
    try {
      await _dio.post(
        ApiManager.apiManager(UrlType.forgotPasswordRequest),
        data: {
          'email': email,
        },
      );
      return;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> verifyNewPassword({
    required String email,
    required String otp,
    required String newpassword,
  }) async {
    try {
      await _dio.post(
        ApiManager.apiManager(UrlType.verifyNewPassword),
        data: {
          'new_password1': newpassword,
          'new_password2': newpassword,
          'otp': otp,
          'email': email,
        },
      );
      return;
    } catch (error) {
      rethrow;
    }
  }
}
