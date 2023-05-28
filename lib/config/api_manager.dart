import 'package:shot_locker/constants/enums.dart';

class ApiManager {
  static const String hostIp = 'https://shot-locker.com';

  // static const String urlPrefix = 'https://credicxo.page.link';

  static String apiManager(UrlType urlType,
      {String? uniqueId, String? otherId}) {
    switch (urlType) {
      //Authentication
      case UrlType.login:
        return '$hostIp/api/account/login';
      case UrlType.googleLogin:
        return '$hostIp/api/account/google';
      case UrlType.facebookLogin:
        return '$hostIp/api/account/facebook';
      case UrlType.appleLogin:
        return '$hostIp/api/account/apple';
      case UrlType.signup:
        return '$hostIp/api/account/signup';
      case UrlType.resignup:
        return '$hostIp/api/account/re-signup';
      case UrlType.resendemailverification:
        return '$hostIp/api/account/resend-email-verify';
      //Forgot password
      case UrlType.forgotPasswordRequest:
        return '$hostIp/api/account/password-reset/request';
      case UrlType.verifyNewPassword:
        return '$hostIp/api/account/password-reset/confirm';
      //
      case UrlType.userProfileDataFetch:
        return '$hostIp/api/account/profile';
      case UrlType.userProfileUpdate:
        return '$hostIp/api/account/profile/update';
      case UrlType.userProfilePhotoUpdate:
        return '$hostIp/api/account/profile-photo';

      //New round
      case UrlType.createNewGameEntry:
        return '$hostIp/api/shot/create-game-entry';

      //Course List
      case UrlType.courseList:
        return '$hostIp/api/shot/course-list';
      case UrlType.courseListFromDB:
        return '$hostIp/api/shot/all-course-list';

      //Fetch course by location
      case UrlType.courseListByLocation:
        return '$hostIp/api/shot/find-distance?$uniqueId';

      //Check game status
      case UrlType.checkLastGameStatus:
        return '$hostIp/api/shot/last-entry/status-check';
      case UrlType.checkShotStatus:
        return '$hostIp/api/shot/prev-next-shot?id=$uniqueId&hole=$otherId';
      case UrlType.checkGameDetailsByHole:
        return '$hostIp/api/shot/update-shot?game=$uniqueId&hole=$otherId';

      case UrlType.checkSavedCoursePrefilledDetails:
        return '$hostIp/api/shot/holes-value/$uniqueId?hole=$otherId';

      //Game shot entry round
      case UrlType.createGameShot:
        return '$hostIp/api/shot/shot-entry/create';
      //Update Game shot entry round
      case UrlType.updateGameShot:
        return '$hostIp/api/shot/shot-entry/retrieve-update/$uniqueId';

      //Update last shot to calculate on backend
      case UrlType.updateLastShot:
        return '$hostIp/api/shot/change-value/holes/$uniqueId';

      //Delete game entry
      case UrlType.deleteGame:
        return '$hostIp/api/shot/update-delete/$uniqueId';

      //Fetch round data for home
      case UrlType.fetchRoundDataForHome:
        return '$hostIp/api/shot/final-result?round=$uniqueId';

      //Fetch user finished game list
      case UrlType.fetchUserGame:
        return '$hostIp/api/shot/user-game-list';

      //Fetch each round data
      case UrlType.fetchRoundScoreDetails:
        return '$hostIp/api/shot/score-board/details/$uniqueId';
      case UrlType.fetchRoundScoreResult:
        return '$hostIp/api/shot/score-board/result/$uniqueId';

      //Range
      case UrlType.fetchSubHeadings:
        return '$hostIp/api/range/category/list?category=$uniqueId';
      case UrlType.fetchArticlesOfsubHeading:
        return '$hostIp/api/range/list?heading=$uniqueId';

      default:
        return 'No API found';
    }
  }
}
