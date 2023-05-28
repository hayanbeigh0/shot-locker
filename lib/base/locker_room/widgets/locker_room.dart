import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shot_locker/base/locker_room/logic/each_round_data/each_round_data_cubit.dart';
import 'package:shot_locker/base/locker_room/screen/each_round_details.dart';
import 'package:shot_locker/base/locker_room/logic/round_manager/round_manager_cubit.dart';
import 'package:shot_locker/base/locker_room/model/round_data_fetch_model.dart';
import 'package:shot_locker/base/locker_room/widgets/header.dart';
import 'package:shot_locker/base/locker_room/widgets/last_games.dart';
import 'package:shot_locker/base/locker_room/widgets/score_grid.dart';
import 'package:shot_locker/utility/data_color_scheme.dart';

class LockerRoom extends StatelessWidget {
  const LockerRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        const Header(),
        const ScoreGrid(),
        SizedBox(height: 25.h),
        const LastGames(),
        SizedBox(height: 20.h),
        BlocBuilder<RoundManagerCubit, RoundManagerState>(
            builder: (context, state) {
          if (state is RoundDataFetched) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
              ),
              height: 330.h,
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(60.h),
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      bottom: TabBar(
                        indicatorColor: Colors.white,
                        indicatorWeight: 1.5,
                        tabs: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: Text(
                              'My Best Shots',
                              style: GoogleFonts.rubik(
                                letterSpacing: 1.0,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: Text(
                              'My Worst Shots',
                              style: GoogleFonts.rubik(
                                letterSpacing: 1.0,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            state.roundDataDetails.results.best5Shots.length,
                            (index) => InkWell(
                              onTap: () async {
                                //Trigger the each round data fetch before navigate
                                BlocProvider.of<EachRoundDataCubit>(context)
                                    .fetchEachRoundData(
                                        context: context,
                                        gameId: state.roundDataDetails.results
                                            .best5Shots[index].game);
                                //
                                await Navigator.of(context).pushNamed(
                                    EachRoundDetails.routeName,
                                    arguments: 'My Best Score');
                              },
                              child: OneShotWidget(
                                st5shot: state
                                    .roundDataDetails.results.best5Shots[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            state.roundDataDetails.results.worst5Shots.length,
                            (index) => InkWell(
                              onTap: () async {
                                BlocProvider.of<EachRoundDataCubit>(context)
                                    .fetchEachRoundData(
                                        context: context,
                                        gameId: state.roundDataDetails.results
                                            .worst5Shots[index].game);
                                await Navigator.of(context).pushNamed(
                                  EachRoundDetails.routeName,
                                  arguments: 'My Worst Score',
                                );
                              },
                              child: OneShotWidget(
                                  st5shot: state.roundDataDetails.results
                                      .worst5Shots[index]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Text(
              'Add new round to begin...',
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 18.sp,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w600,
              ),
            );
          }
        }),
        SizedBox(height: 50.h)
      ],
    );
  }
}

class OneShotWidget extends StatelessWidget {
  final St5Shot st5shot;
  const OneShotWidget({
    Key? key,
    required this.st5shot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          //color: const Color(0xffFDFDFD),
          color: const Color(0xff111619),
          borderRadius: BorderRadius.circular(10.r),
        ),
        //  color: Colors.grey.shade900,

        height: 250.h,
        width: 180.w,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text(
                    'SG  ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    st5shot.sg,
                    style: TextStyle(
                      color: DataColorScheme.dataColor(data: st5shot.sg),
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Round No',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 15.sp,
              //       ),
              //     ),
              //     Text(
              //       st5shot.roundNo,
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 15.sp,
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    st5shot.date,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hole No',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    st5shot.holeNo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shot No',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    st5shot.shotNo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Surface',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    st5shot.surface,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'St.Dist.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    '${st5shot.startDistance} ${st5shot.surface.toLowerCase().contains('g') ? "feet" : "yds"}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
