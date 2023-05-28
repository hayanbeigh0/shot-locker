// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shot_locker/base/locker_room/logic/each_round_data/each_round_data_cubit.dart';
import 'package:shot_locker/base/locker_room/model/round_data_fetch_model.dart';
import 'package:shot_locker/base/logic/round_info.dart';
import 'package:shot_locker/base/new-round/logic/rounds_data_entry_manager/rounds_data_entry_manager_dart_cubit.dart';
import 'package:shot_locker/base/new-round/screens/new_round_screen.dart';
import 'package:shot_locker/constants/constants.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';
import 'package:shot_locker/utility/custom_appbar.dart';
import 'package:shot_locker/utility/data_color_scheme.dart';
import 'package:shot_locker/utility/loading_indicator.dart';

class EachRoundDetails extends StatefulWidget {
  final bool isScoreCard;
  final String? heading;
  static const routeName = 'eachRoundDetails_screen';

  const EachRoundDetails({
    Key? key,
    this.isScoreCard = false,
    this.heading,
  }) : super(key: key);

  @override
  _EachRoundDetailsState createState() => _EachRoundDetailsState();
}

class _EachRoundDetailsState extends State<EachRoundDetails> {
  late String _heading;

  @override
  void initState() {
    if (widget.heading != null && widget.isScoreCard) {
      _heading = widget.heading!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    if (!widget.isScoreCard && widget.heading == null) {
      _heading = ModalRoute.of(context)!.settings.arguments as String;
    }

    final tableHeadingTextStyle = GoogleFonts.rubik(
      fontSize: 15.sp,
      color: Colors.white,
      letterSpacing: 2,
      fontWeight: FontWeight.w400,
    );

    final tableContentTextStyle = GoogleFonts.rubik(
      fontSize: 16.sp,
      color: Colors.white,
      letterSpacing: 2,
      fontWeight: FontWeight.w400,
    );

    return SafeArea(
      child: Scaffold(
        body: ShotLockerBackgroundTheme(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              children: <Widget>[
                if (!widget.isScoreCard)
                  Row(
                    children: [
                      Expanded(
                        child: CustomAppBar(
                          showProfileImage: false,
                          centreWidget: Text(
                            _heading,
                            style: GoogleFonts.rubik(
                              fontSize: 16.sp,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      BlocBuilder<EachRoundDataCubit, EachRoundDataState>(
                        builder: (context, state) {
                          if (state is EachRoundDataFetched) {
                            return EditButton(
                              gameId: state.scoreBoard.gameId,
                              holeNumber: state.roundDetails.first.hole,
                            );
                          } else {
                            return SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: LoadingIndicator(strokeWidth: 2.w),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                SizedBox(height: 20.h),
                BlocBuilder<EachRoundDataCubit, EachRoundDataState>(
                  builder: (context, state) {
                    if (state is EachRoundDataFetched) {
                      return Expanded(
                        child: ListView(
                          children: [
                            // if (_heading.contains('My round') ||
                            //     widget.isScoreCard)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                ),
                                child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Expected Strokes',
                                          style: tableHeadingTextStyle,
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          state.scoreBoard.course,
                                          style: tableContentTextStyle,
                                        ),
                                      ],
                                    ),
                                    Divider(color: Colors.white, height: 20.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Score',
                                                style: tableHeadingTextStyle,
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                state.scoreBoard.score,
                                                style: tableContentTextStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                'S.G',
                                                style: tableHeadingTextStyle,
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                state.scoreBoard.totalStrokes,
                                                style: GoogleFonts.rubik(
                                                  fontSize: 16.sp,
                                                  color:
                                                      DataColorScheme.dataColor(
                                                    data: state.scoreBoard
                                                        .totalStrokes,
                                                  ),
                                                  letterSpacing: 2,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(color: Colors.white, height: 20.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                'TEE SHOTS',
                                                style: tableHeadingTextStyle,
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                state.scoreBoard.driver,
                                                style: tableContentTextStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                'APPROACHES',
                                                style: tableHeadingTextStyle,
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                state.scoreBoard.approches,
                                                style: tableContentTextStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(color: Colors.white, height: 20.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                'SHORT GAME',
                                                style: tableHeadingTextStyle,
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                state.scoreBoard.shortGames,
                                                style: tableContentTextStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                'PUTTING',
                                                style: tableHeadingTextStyle,
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                state.scoreBoard.puttings,
                                                style: tableContentTextStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: deviceSize.height * 0.02),
                            Column(
                              children: List.generate(
                                state.roundDetails.length,
                                (index) => ExpansionCard(
                                  key: Key(index.toString()),
                                  holeDetail: state.roundDetails[index],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else if (state is EachRoundDataLoadingFailed) {
                      return Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(state.error),
                        ),
                      );
                    } else if (state is EachRoundDataInitial) {
                      return Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text('No game data found!'),
                        ),
                      );
                    } else {
                      return const Expanded(
                        child: LoadingIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  final String gameId;
  final String holeNumber;

  EditButton({
    Key? key,
    required this.gameId,
    required this.holeNumber,
  }) : super(key: key);
  RoundInfo roundInfo = RoundInfo();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        await HapticFeedback.lightImpact();
        log('Game Id<><> : $gameId');
        final isAllowedToEdit = await context
            .read<RoundsDataEntryManagerDartCubit>()
            .editGameDetails(
              context,
              gameId: gameId,
              holeNumber: holeNumber,
            );
        roundInfo.setCourse(int.parse(gameId));
        if (isAllowedToEdit) {
          Navigator.of(context).pushNamed(
            NewRoundScreen.routeName,
            arguments: roundInfo,
          );
        }
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        overlayColor: MaterialStateProperty.all(Colors.white10),
      ),
      child: const Text('Edit'),
    );
  }
}

class ExpansionCard extends StatelessWidget {
  final HoleDetail holeDetail;
  const ExpansionCard({
    Key? key,
    required this.holeDetail,
  }) : super(key: key);

  DataCell _dataEntry(String value, {Color? colorScheme}) {
    return DataCell(
      Center(
        child: Text(
          value,
          style: TextStyle(
            color: colorScheme ?? Colors.white,
          ),
          //   style: textStyle?? const TextStyle(),
        ),
      ),
    );
  }

  DataColumn _dataHeader(String value) {
    return DataColumn(
      label: Text(
        value,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String pgaStrokes = holeDetail.pgaStrokesAvg;
    String strokeGainedAverage = holeDetail.strokesGainedAvg;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: ExpansionTileCard(
        key: key,
        baseColor: Constants.boxBgColor,
        expandedColor: Constants.boxBgColor,
        leading: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(child: Text('H-${holeDetail.hole}'))),
        title: Row(
          children: [
            Text(
              'PGA Strokes Avg :  ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
            Text(
              pgaStrokes,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              'Strokes Gained Avg :  ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
            Text(
              strokeGainedAverage,
              style: TextStyle(
                color: DataColorScheme.dataColor(data: strokeGainedAverage),
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
        children: <Widget>[
          Divider(thickness: 1, height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 30.w,
              columns: [
                // _dataHeader('Shot no'),
                _dataHeader('Starting\nDistance'),
                _dataHeader('Surface'),
                _dataHeader('Penalty'),
                // _dataHeader('PGA Strokes'),
                _dataHeader('Strokes\nGained'),
              ],
              rows: List.generate(
                holeDetail.details.length,
                (index) => DataRow(cells: [
                  // _dataEntry((index + 1).toString()),
                  _dataEntry(holeDetail.details[index].startDistance),
                  _dataEntry(holeDetail.details[index].surface),
                  _dataEntry(holeDetail.details[index].penalty),
                  // _dataEntry(holeDetail.details[index].pgaStrokes),
                  _dataEntry(
                    holeDetail.details[index].strokesGained,
                    colorScheme: DataColorScheme.dataColor(
                      data: holeDetail.details[index].strokesGained,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
