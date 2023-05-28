import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shot_locker/authentication/logic/authentication/authentication_bloc.dart';
import 'package:shot_locker/authentication/logic/forgot_password_manager/forgot_password/forgot_password_cubit.dart';
import 'package:shot_locker/authentication/logic/forgot_password_manager/new_password_verification_error_handler/new_password_verification_error_handler_cubit.dart';
import 'package:shot_locker/authentication/logic/login/login_bloc.dart';
import 'package:shot_locker/authentication/screen/auth_screen.dart';
import 'package:shot_locker/base/explore/logic/cubit/explore_cubit.dart';
import 'package:shot_locker/base/golfer/logic/profile_image/profileimage_cubit.dart';
import 'package:shot_locker/base/golfer/logic/user_profile/user_profile_bloc.dart';
import 'package:shot_locker/base/locker_room/logic/display_graph_data/display_graph_data_cubit.dart';
import 'package:shot_locker/base/locker_room/logic/each_round_data/each_round_data_cubit.dart';
import 'package:shot_locker/base/locker_room/logic/round_manager/round_manager_cubit.dart';
import 'package:shot_locker/base/logic/go_to_home/go_to_home_cubit.dart';
import 'package:shot_locker/base/new-round/logic/add_update_button/addupdatebutton_cubit.dart';
import 'package:shot_locker/base/new-round/logic/hole_counter/hole_counter_cubit.dart';
import 'package:shot_locker/base/new-round/logic/hole_list/hole_list_cubit.dart';
import 'package:shot_locker/base/new-round/logic/numberpad/numberpaddata_cubit.dart';
import 'package:shot_locker/base/new-round/logic/penalty_handler/penaltytype_cubit.dart';
import 'package:shot_locker/base/new-round/logic/rounds_data_entry_manager/rounds_data_entry_manager_dart_cubit.dart';
import 'package:shot_locker/base/new-round/logic/shot_counter/shot_counter_cubit.dart';
import 'package:shot_locker/base/new-round/logic/surface_selector/surface_selector_cubit.dart';
import 'package:shot_locker/base/range/logic/range_article/range_article_cubit.dart';
import 'package:shot_locker/base/range/logic/range_data_manager/range_data_manager_cubit.dart';
import 'package:shot_locker/config/routes/application_page_routes.dart';
import 'package:shot_locker/utility/control_media_play/control_meadia_play_cubit.dart';
import 'package:shot_locker/utility/loading_screen.dart';
import 'base/screen/base_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authenticationBloc = AuthenticationBloc();

  @override
  void initState() {
    _authenticationBloc.add(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authenticationBloc),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          ),
        ),
        BlocProvider<NewPasswordVerificationErrorHandlerCubit>(
          create: (context) => NewPasswordVerificationErrorHandlerCubit(),
        ),
        BlocProvider<ForgotPasswordCubit>(
          create: (context) => ForgotPasswordCubit(
            newPasswordVerificationErrorHandlerCubit:
                context.read<NewPasswordVerificationErrorHandlerCubit>(),
          ),
        ),
        BlocProvider<UserProfileBloc>(
          create: (context) => UserProfileBloc(),
        ),
        BlocProvider<ShotCounterCubit>(
          create: (context) => ShotCounterCubit(),
        ),
        BlocProvider<HoleCounterCubit>(
          create: (context) => HoleCounterCubit(),
        ),
        BlocProvider<HoleListCubit>(
          create: (context) => HoleListCubit(),
        ),
        BlocProvider<SurfaceSelectorCubit>(
          create: (context) => SurfaceSelectorCubit(),
        ),
        BlocProvider<NumberPadDataCubit>(
          create: (context) => NumberPadDataCubit(),
        ),
        BlocProvider<PenaltytypeCubit>(
          create: (context) => PenaltytypeCubit(),
        ),
        BlocProvider<AddupdatebuttonCubit>(
          create: (context) => AddupdatebuttonCubit(),
        ),
        BlocProvider<RoundsDataEntryManagerDartCubit>(
          create: (context) => RoundsDataEntryManagerDartCubit(
            addupdatebuttonCubit:
                BlocProvider.of<AddupdatebuttonCubit>(context),
            shotCounterCubit: BlocProvider.of<ShotCounterCubit>(context),
            holeCounterCubit: BlocProvider.of<HoleCounterCubit>(context),
            holeListCubit: BlocProvider.of<HoleListCubit>(context),
            surfaceSelectorCubit:
                BlocProvider.of<SurfaceSelectorCubit>(context),
            numberPadDataCubit: BlocProvider.of<NumberPadDataCubit>(context),
            penaltytypeCubit: BlocProvider.of<PenaltytypeCubit>(context),
          ),
        ),
        BlocProvider<GoToHomeCubit>(
          create: (context) => GoToHomeCubit(),
        ),
        BlocProvider<DisplayGraphDataCubit>(
          create: (context) => DisplayGraphDataCubit(),
        ),
        BlocProvider<EachRoundDataCubit>(
          create: (context) => EachRoundDataCubit(),
        ),
        BlocProvider<RoundManagerCubit>(
          create: (context) => RoundManagerCubit(
              displayGraphDataCubit:
                  BlocProvider.of<DisplayGraphDataCubit>(context)),
        ),
        BlocProvider<RangeArticleCubit>(
          create: (context) => RangeArticleCubit(),
        ),
        BlocProvider<RangeDataManagerCubit>(
          create: (context) => RangeDataManagerCubit(
            rangeArticleCubit: BlocProvider.of<RangeArticleCubit>(context),
          ),
        ),
        BlocProvider<ControlMeadiaPlayCubit>(
          create: (context) => ControlMeadiaPlayCubit(),
        ),
        BlocProvider<ExploreCubit>(
          create: (context) => ExploreCubit(),
        ),
        BlocProvider<ProfileimageCubit>(
          create: (context) => ProfileimageCubit(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(
          WidgetsBinding.instance.window.physicalSize.width /
              WidgetsBinding.instance.window.devicePixelRatio,
          WidgetsBinding.instance.window.physicalSize.height /
              WidgetsBinding.instance.window.devicePixelRatio,
        ),
        builder: () => MaterialApp(
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            textTheme: GoogleFonts.nunitoTextTheme(const TextTheme()),
          ),
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationUninitialized) {
                return const LoadingScreen();
              } else if (state is AuthenticationAuthenticated ||
                  state is AuthenticatedAnonymously) {
                return const BaseScreen();
              } else if (state is AuthenticationUnauthenticated) {
                return const AuthScreen();
                // return const BaseScreen();
              } else {
                return const LoadingScreen();
              }
            },
          ),
          onGenerateRoute: ScreenRouter().onGeneratedRouter,
        ),
      ),
    );
  }
}
