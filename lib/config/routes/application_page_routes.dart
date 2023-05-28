import 'package:flutter/material.dart';
import 'package:shot_locker/authentication/screen/auth_screen.dart';
import 'package:shot_locker/authentication/screen/forgot_password_screen.dart';
import 'package:shot_locker/base/golfer/screen/profile_setting_screen.dart';
import 'package:shot_locker/base/golfer/widgets/faqs_screen.dart';
import 'package:shot_locker/base/golfer/widgets/terms_of_use.dart';
import 'package:shot_locker/base/locker_room/screen/dash_board_screen.dart';
import 'package:shot_locker/base/logic/round_info.dart';
import 'package:shot_locker/base/new-round/screens/new_round_screen.dart';
import 'package:shot_locker/base/new-round/screens/round_entry_screens/select_course_screen.dart';
import 'package:shot_locker/base/new-round/screens/round_entry_screens/select_date_screen.dart';
import 'package:shot_locker/base/range/screen/range_article_screen.dart';
import 'package:shot_locker/base/screen/base_screen.dart';
import 'package:shot_locker/utility/loading_indicator.dart';
import 'package:shot_locker/base/locker_room/graph/screen/shot_details_graph_screen.dart';

import '../../base/locker_room/screen/each_round_details.dart';

class ScreenRouter {
  ScreenRouter();

  Route onGeneratedRouter(RouteSettings routeSettings) {
    String? routeName = routeSettings.name;
    switch (routeName) {
      case BaseScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: routeSettings.arguments),
          builder: (_) => const BaseScreen(),
        );
      //
      case ForgotPasswwordScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: routeSettings.arguments),
          builder: (_) => const ForgotPasswwordScreen(),
        );
      //
      case DashBoardScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: routeSettings.arguments),
          builder: (_) => const DashBoardScreen(),
        );
      //
      case AuthScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: routeSettings.arguments),
          builder: (_) => const AuthScreen(),
        );
      //
      case ProfileSettingScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: routeSettings.arguments),
          builder: (_) => const ProfileSettingScreen(),
        );
      //

      //
      case SelectDateScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: routeSettings.arguments),
          builder: (_) => const SelectDateScreen(),
        );

      //
      case SelectCourseScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: routeSettings.arguments),
          builder: (_) => const SelectCourseScreen(),
        );

      //
      // case SelectHoleTypeScreen.routeName:
      //   return MaterialPageRoute(
      //     settings: RouteSettings(arguments: routeSettings.arguments),
      //     builder: (_) => const SelectHoleTypeScreen(),
      //   );

      //
      case EachRoundDetails.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: routeSettings.arguments),
          builder: (_) => const EachRoundDetails(),
        );

      //
      case ShotDetailsGraphScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: routeSettings.arguments),
          builder: (_) => const ShotDetailsGraphScreen(),
        );

      //
      case RangeArticlesScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: routeSettings.arguments),
          builder: (_) => const RangeArticlesScreen(),
        );
      //
      case TermsOfUse.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: routeSettings.arguments),
          builder: (_) => const TermsOfUse(),
        );
      //
      case NewRoundScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: routeSettings.arguments),
          builder: (_) {
            RoundInfo roundInfo = routeSettings.arguments as RoundInfo;
            return NewRoundScreen(
              roundInfo: roundInfo,
            );
          },
        );
      //
      case FAQsScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: routeSettings.arguments),
          builder: (_) => const FAQsScreen(),
        );

      default:
        return errorRoute();
    }
  }

  static Route errorRoute() => MaterialPageRoute(
        settings: const RouteSettings(name: '/error'),
        builder: (_) => const Scaffold(
          body: Center(
            child: LoadingIndicator(
              color: Colors.red,
              strokeWidth: 5,
            ),
          ),
        ),
      );
}
