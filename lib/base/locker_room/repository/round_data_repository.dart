import 'package:dio/dio.dart';
import 'package:shot_locker/authentication/model/auth_model.dart';
import 'package:shot_locker/config/api_manager.dart';
import 'package:shot_locker/constants/enums.dart';

class RoundDataRepository {
  Future<Response> fetchRoundDataForHome({
    required TokenData tokenData,
    required String roundName,
  }) async {
    try {
      return await Dio().get(
        ApiManager.apiManager(
          UrlType.fetchRoundDataForHome,
          uniqueId: roundName,
        ),
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

  Future<Response> fetchShotDetails({
    required TokenData tokenData,
    required String roundName,
    required String shotName,
  }) async {
    try {
      return await Dio().get(
        '${ApiManager.hostIp}/api/shot/$shotName?round=$roundName',
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

  Future<Response> fetchUserFinishedGameList({
    required TokenData tokenData,
  }) async {
    try {
      return await Dio().get(
        ApiManager.apiManager(UrlType.fetchUserGame),
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
