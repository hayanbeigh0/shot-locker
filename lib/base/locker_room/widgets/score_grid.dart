import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shot_locker/base/locker_room/graph/screen/shot_details_graph_screen.dart';
import 'package:shot_locker/base/locker_room/logic/round_manager/round_manager_cubit.dart';
import 'package:shot_locker/utility/data_color_scheme.dart';

class ScoreGrid extends StatelessWidget {
  const ScoreGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoundManagerCubit, RoundManagerState>(
      builder: (context, state) {
        if (state is RoundDataFetched) {
          return Column(
            children: [
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OneScoreWidget(
                    onTap: () async => await Navigator.of(context).pushNamed(
                      ShotDetailsGraphScreen.routeName,
                      arguments: 'tee-shot',
                    ),
                    logoText: 'D',
                    label: 'DRIVING',
                    score: state.roundDataDetails.results.scoreBoard.driver,
                    borderColor: DataColorScheme.dataColor(
                      data: state.roundDataDetails.results.scoreBoard.driver,
                    ),
                  ),
                  OneScoreWidget(
                    onTap: () async => await Navigator.of(context).pushNamed(
                      ShotDetailsGraphScreen.routeName,
                      arguments: 'approaches',
                    ),
                    logoText: 'A',
                    label: 'APPROACH',
                    score: state.roundDataDetails.results.scoreBoard.approches,
                    borderColor: DataColorScheme.dataColor(
                      data: state.roundDataDetails.results.scoreBoard.approches,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OneScoreWidget(
                    onTap: () async => await Navigator.of(context).pushNamed(
                      ShotDetailsGraphScreen.routeName,
                      arguments: 'short-game',
                    ),
                    logoText: 'S',
                    label: 'SHORT GAME',
                    score: state.roundDataDetails.results.scoreBoard.shortGames,
                    borderColor: DataColorScheme.dataColor(
                      data:
                          state.roundDataDetails.results.scoreBoard.shortGames,
                    ),
                  ),
                  OneScoreWidget(
                    onTap: () async => await Navigator.of(context).pushNamed(
                      ShotDetailsGraphScreen.routeName,
                      arguments: 'putting',
                    ),
                    logoText: 'P',
                    label: 'PUTTING',
                    score: state.roundDataDetails.results.scoreBoard.puttings,
                    borderColor: DataColorScheme.dataColor(
                      data: state.roundDataDetails.results.scoreBoard.puttings,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        //Default state for the 1st user, when there is no data to show.
        else if (state is RoundDataEmptyState) {
          return Column(
            children: [
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OneScoreWidget(
                    onTap: () {},
                    logoText: 'D',
                    label: 'DRIVING',
                    score: 'N/A',
                    borderColor: Colors.white,
                  ),
                  OneScoreWidget(
                    onTap: () {},
                    logoText: 'A',
                    label: 'APPROACH',
                    score: 'N/A',
                    borderColor: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OneScoreWidget(
                    onTap: () {},
                    logoText: 'S',
                    label: 'SHORT GAME',
                    score: 'N/A',
                    borderColor: Colors.white,
                  ),
                  OneScoreWidget(
                    onTap: () {},
                    logoText: 'P',
                    label: 'PUTTING',
                    score: 'N/A',
                    borderColor: Colors.white,
                  ),
                ],
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class OneScoreWidget extends StatelessWidget {
  final String label;
  final String score;
  final String logoText;
  final Color borderColor;
  final VoidCallback onTap;

  const OneScoreWidget({
    Key? key,
    required this.logoText,
    required this.label,
    required this.score,
    required this.borderColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 70.r,
        backgroundColor: borderColor,
        child: CircleAvatar(
          radius: 65.r,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 7.h),
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                score,
                style: GoogleFonts.nunito(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
