import 'package:dio/dio.dart';
import 'package:shot_locker/authentication/model/auth_model.dart';
import 'package:shot_locker/config/api_manager.dart';
import 'package:shot_locker/constants/enums.dart';

class RangeDataRepository {
    Future<Response> fetchSubHeading({
    required TokenData tokenData,
    required String heading,
  }) async {
    try {
      return await Dio().get(
        ApiManager.apiManager(
          UrlType.fetchSubHeadings,
          uniqueId: heading,
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
    Future<Response> fetchArticlesFromSubHeading({
    required TokenData tokenData,
    required String subHeading,
  }) async {
    try {
      return await Dio().get(
        ApiManager.apiManager(
          UrlType.fetchArticlesOfsubHeading,
          uniqueId: subHeading,
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
