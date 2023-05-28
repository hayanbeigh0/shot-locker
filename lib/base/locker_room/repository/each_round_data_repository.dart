import 'package:dio/dio.dart';
import 'package:shot_locker/authentication/model/auth_model.dart';
import 'package:shot_locker/config/api_manager.dart';
import 'package:shot_locker/constants/enums.dart';

class EachRoundDataRepository {
  Future<Response> fetchEachRoundScoreDetails({
    required TokenData tokenData,
    required String gameId,
  }) async {
    try {
      return await Dio().get(
        ApiManager.apiManager(
          UrlType.fetchRoundScoreDetails,
          uniqueId: gameId,
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

  Future<Response> fetchEachRoundScore({
    required TokenData tokenData,
    required String gameId,
  }) async {
    try {
      return await Dio().get(
        ApiManager.apiManager(
          UrlType.fetchRoundScoreResult,
          uniqueId: gameId,
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
}
