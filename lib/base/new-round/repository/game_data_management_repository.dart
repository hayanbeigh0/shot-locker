import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shot_locker/authentication/model/auth_model.dart';
import 'package:shot_locker/base/logic/round_info.dart';
import 'package:shot_locker/base/new-round/model/course_list_model.dart';
import 'package:shot_locker/base/new-round/util/penalty_enum.dart';
import 'package:shot_locker/config/api_manager.dart';
import 'package:shot_locker/constants/enums.dart';

class GameDataManagementRepository {
  final dio = Dio();
  Future<Response> savedCourseListRepository(
      {required TokenData tokenData}) async {
    try {
      return await dio.get(
        ApiManager.apiManager(UrlType.courseList),
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

  Future<Response> searchCourseListRepository(
      {required TokenData tokenData,
      required LocationData locationData}) async {
    try {
      locationData.longitude;

      return await dio.get(
        ApiManager.apiManager(
          UrlType.courseListByLocation,
          uniqueId:
              'latitude=${locationData.latitude}&longitude=${locationData.longitude}',
          // 'latitude=53.394227&longitude=-6.144867', //demo purpose
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

  Future<List<CourseWithDistanceListModel>> courseListInDBRepository({
    required TokenData tokenData,
  }) async {
    try {
      return await dio
          .get(
            ApiManager.apiManager(
              UrlType.courseListFromDB,
            ),
            options: Options(
              headers: {
                'Authorization': 'Bearer ${tokenData.token}',
              },
            ),
          )
          .then(
            (response) => List<CourseWithDistanceListModel>.from(
              (response.data)
                  .map((x) => CourseWithDistanceListModel.fromMap(x)),
            ),
          );
    } catch (error) {
      // print(error);
      return [];
    }
  }

  Future<Response> createNewGame({
    required TokenData tokenData,
    required DateTime date,
    required String golfCourseName,
    required int holeType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'date': DateFormat('yyyy-MM-dd').format(date),
        'golf_course_name': golfCourseName,
        'type': holeType,
      });

      return await dio.post(
        ApiManager.apiManager(
          UrlType.createNewGameEntry,
        ),
        data: data,
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

  Future<Response> checkLastGameStatus({
    required TokenData tokenData,
  }) async {
    try {
      return await dio.get(
        ApiManager.apiManager(UrlType.checkLastGameStatus),
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

  Future<Response> checkSavedCoursePrefilledDetais({
    required TokenData tokenData,
    required RoundInfo roundInfo,
    required int holeNumber,
  }) async {
    try {
      Response a;
      a = await dio.get(
        ApiManager.apiManager(
          UrlType.checkSavedCoursePrefilledDetails,
          uniqueId: roundInfo.teeId.toString(),
          otherId: 'h${holeNumber.toString()}',
        ),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${tokenData.token}',
          },
        ),
      );
      // print(a.data);
      return a;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> updateLastShotValue({
    required TokenData tokenData,
    required int gameId,
  }) async {
    try {
      return await dio.get(
        ApiManager.apiManager(
          UrlType.updateLastShot,
          uniqueId: gameId.toString(),
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

  Future<Response> checkShotStatus({
    required TokenData tokenData,
    required int queryShot,
    required int holeNumber,
  }) async {
    try {
      return await dio.get(
        ApiManager.apiManager(
          UrlType.checkShotStatus,
          uniqueId: queryShot.toString(),
          otherId: holeNumber.toString(),
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

  Future<Response> checkGameDetailsByHoleStatus({
    required TokenData tokenData,
    required String gameId,
    required String holeNumber,
  }) async {
    try {
      return await dio.get(
        ApiManager.apiManager(
          UrlType.checkGameDetailsByHole,
          uniqueId: gameId,
          otherId: holeNumber,
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

  Future<Response> deleteCurrentGameEntry({
    required TokenData tokenData,
    required int gameId,
  }) async {
    try {
      return await dio.delete(
        ApiManager.apiManager(
          UrlType.deleteGame,
          uniqueId: gameId.toString(),
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

  Future<Response> finishShotEntry({
    required TokenData tokenData,
    required int shotId,
  }) async {
    try {
      return await dio.get(
        '${ApiManager.hostIp}/api/shot/change-status?shot_id=$shotId&is_finished=True',
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

  Future<Response> unFinishShotEntry({
    required TokenData tokenData,
    required int shotId,
  }) async {
    try {
      return await dio.get(
        '${ApiManager.hostIp}/api/shot/change-status?shot_id=$shotId&is_finished=False',
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

  Future<Response> createShotEntry({
    required TokenData tokenData,
    required int gameId,
    required int currentSelectedHole,
    required String startDistance,
    required String surfaceType,
    required PenaltyType penaltyType,
    required bool isScratch,
  }) async {
    try {
      final data = {
        'game': gameId,
        'hole': currentSelectedHole,
        'start_distance': startDistance,
        'surface': surfaceType == 'Recovery' ? 'X' : surfaceType[0],
        'penalty': penaltyType == PenaltyType.doublePenalty
            ? 2
            : penaltyType == PenaltyType.penalty
                ? 1
                : 0,
        'is_scratch': isScratch,
      };
      return await dio.post(
        ApiManager.apiManager(UrlType.createGameShot),
        data: data,
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

  Future<Response> updateShotEntry({
    required TokenData tokenData,
    required int currentShotId,
    required int gameId,
    required int currentSelectedHole,
    required String startDistance,
    required String surfaceType,
    required PenaltyType penaltyType,
  }) async {
    try {
      final data = {
        'game': gameId,
        'hole': currentSelectedHole,
        'start_distance': startDistance,
        'surface': surfaceType == 'Recovery' ? 'X' : surfaceType[0],
        'penalty': penaltyType == PenaltyType.doublePenalty
            ? 2
            : penaltyType == PenaltyType.penalty
                ? 1
                : 0,
      };
      return await dio.put(
        ApiManager.apiManager(
          UrlType.updateGameShot,
          uniqueId: currentShotId.toString(),
        ),
        data: data,
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
