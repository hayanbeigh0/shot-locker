import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shot_locker/base/locker_room/logic/each_round_data/each_round_data_cubit.dart';
import 'package:shot_locker/base/locker_room/screen/each_round_details.dart';
import 'package:shot_locker/base/locker_room/logic/round_manager/round_manager_cubit.dart';
import 'package:shot_locker/constants/constants.dart';

class LastGames extends StatelessWidget {
  const LastGames({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _deviceSize = MediaQuery.of(context).size;
    return BlocBuilder<RoundManagerCubit, RoundManagerState>(
      builder: (context, state) {
        if (state is RoundDataFetched) {
          return Column(children: [
            Text(
              'My Rounds',
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 18.sp,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
            Column(
              children: List.generate(
                state.roundDataDetails.gameDetails.length,
                (index) => InkWell(
                  onTap: () {
                    //Trigger the each round data fetch before navigate
                    BlocProvider.of<EachRoundDataCubit>(context)
                        .fetchEachRoundData(
                      context: context,
                      gameId: state.roundDataDetails.gameDetails[index].gameId,
                    );

                    Navigator.of(context).pushNamed(
                      EachRoundDetails.routeName,
                      arguments:
                          '${state.roundDataDetails.gameDetails[index].golfName} (${state.roundDataDetails.gameDetails[index].date})',
                    );
                  },
                  child: Card(
                    color: Constants.boxBgColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 20.h,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    state.roundDataDetails.gameDetails[index]
                                        .date,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    state.roundDataDetails.gameDetails[index]
                                        .golfName,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      letterSpacing: 1.2,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Wrap(
                                    children: [
                                      Text(
                                        'Score: ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.2,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      Text(
                                        state.roundDataDetails
                                            .gameDetails[index].score,
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1.2,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 12.sp,
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ]);
        } else {
          return Container();
        }
      },
    );
  }
}
