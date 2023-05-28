import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shot_locker/base/locker_room/graph/short_chart_table/approach_chart_table.dart';
import 'package:shot_locker/base/locker_room/graph/short_chart_table/driver_chart_table.dart';
import 'package:shot_locker/base/locker_room/graph/short_chart_table/putting_chart_table.dart';
import 'package:shot_locker/base/locker_room/graph/short_chart_table/short_game_chart_table.dart';
import 'package:shot_locker/base/locker_room/graph/shot_graph_chart/approach_shot_graph_chat.dart';
import 'package:shot_locker/base/locker_room/graph/shot_graph_chart/driver_shot_graph_chat.dart';
import 'package:shot_locker/base/locker_room/graph/shot_graph_chart/putting_shot_graph_chart.dart';
import 'package:shot_locker/base/locker_room/graph/shot_graph_chart/short_game_graph_chat.dart';
import 'package:shot_locker/base/locker_room/logic/display_graph_data/display_graph_data_cubit.dart';
import 'package:shot_locker/base/locker_room/logic/round_manager/round_manager_cubit.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';
import 'package:shot_locker/utility/custom_appbar.dart';
import 'package:shot_locker/utility/loading_indicator.dart';

class ShotDetailsGraphScreen extends StatelessWidget {
  static const routeName = '/shot_details_screen';

  const ShotDetailsGraphScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shotName = ModalRoute.of(context)!.settings.arguments as String;
    BlocProvider.of<RoundManagerCubit>(context)
        .fetchShotDetails(context: context, shotName: shotName);
    _customAppBar({required String heading}) => CustomAppBar(
          showProfileImage: false,
          centreWidget: Text(
            heading,
            style: GoogleFonts.rubik(
              fontSize: 18.sp,
              color: Colors.white,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
    return Scaffold(
      body: SafeArea(
        child: ShotLockerBackgroundTheme(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
              vertical: 10.h,
            ),
            child: BlocBuilder<DisplayGraphDataCubit, DisplayGraphDataState>(
                builder: (context, state) {
              if (state is GraphDataLoadingError) {
                return Center(child: Text(state.error));
              } else if (state is DisplayTeeGraphData) {
                return Column(
                  children: [
                    _customAppBar(heading: state.heading),
                    SizedBox(height: 100.h),
                    DriverShotGraphChart(driverModel: state.driverModel),
                    SizedBox(height: 40.h),
                    DriverChartTable(driverModel: state.driverModel),
                  ],
                );
              } else if (state is DisplayApproachGraphData) {
                return Column(
                  children: [
                    _customAppBar(heading: state.heading),
                    SizedBox(height: 100.h),
                    ApproacheShortGraphChart(
                      approachesModel: state.approachesModel,
                    ),
                    SizedBox(height: 40.h),
                    ApproacheChartTable(
                      approachesModel: state.approachesModel,
                    ),
                  ],
                );
              } else if (state is DisplayShortGameGraphData) {
                return Column(
                  children: [
                    _customAppBar(heading: state.heading),
                    SizedBox(height: 100.h),
                    ShortGameGraphChart(
                      shortGameModel: state.shortGameModel,
                    ),
                    SizedBox(height: 40.h),
                    ShortGameChartTable(
                      shortGameModel: state.shortGameModel,
                    ),
                  ],
                );
              } else if (state is DisplayPuttingGraphData) {
                return Column(
                  children: [
                    _customAppBar(heading: state.heading),
                    SizedBox(height: 100.h),
                    PuttingShortGraphChart(
                      puttingModel: state.puttingModel,
                    ),
                    SizedBox(height: 40.h),
                    PuttingChartTable(
                      puttingModel: state.puttingModel,
                    ),
                  ],
                );
              } else {
                return const LoadingIndicator();
              }
            }),
          ),
        ),
      ),
    );
  }
}
