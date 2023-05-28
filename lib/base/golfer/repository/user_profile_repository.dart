import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shot_locker/authentication/model/auth_model.dart';
import 'package:shot_locker/base/golfer/model/user_profile_fetch_model.dart';
import 'package:shot_locker/config/api_manager.dart';
import 'package:shot_locker/constants/enums.dart';

class UserProfileRepository {
  final _dio = Dio();

  Future<Response> fetchUserProfileDetails(TokenData tokenData) async {
    try {
      return await _dio
          .get(
              ApiManager.apiManager(
                UrlType.userProfileDataFetch,
              ),
              options: Options(headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${tokenData.token}',
              }))
          .then((response) => response);
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> changeUserProfileDetails(
      TokenData tokenData, UserProfileFetchModel userProfileFetchModel) async {
    try {
      FormData _data = FormData.fromMap(userProfileFetchModel.toMap());
      return await Dio().put(
        ApiManager.apiManager(
          UrlType.userProfileUpdate,
        ),
        data: _data,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${tokenData.token}',
          },
        ),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> changeUserProfilePhoto(
      TokenData tokenData, File imagePath) async {
    try {
      final _imageFile = await MultipartFile.fromFile(imagePath.path);
      FormData _data = FormData.fromMap({'photo': _imageFile});
      await Dio().put(
        ApiManager.apiManager(
          UrlType.userProfilePhotoUpdate,
        ),
        data: _data,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${tokenData.token}',
          },
        ),
      );
    } catch (error) {
      rethrow;
    }
  }
}
