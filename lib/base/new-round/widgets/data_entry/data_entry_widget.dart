// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/new-round/logic/hole_counter/hole_counter_cubit.dart';
import 'package:shot_locker/base/new-round/logic/hole_list/hole_list_cubit.dart';
import 'package:shot_locker/base/new-round/logic/rounds_data_entry_manager/rounds_data_entry_manager_dart_cubit.dart';
import 'package:shot_locker/constants/constants.dart';
import '../../../logic/round_info.dart';
import 'shot_entry.dart';

class DataEntryWidget extends StatelessWidget {
  final RoundInfo roundInfo;
  const DataEntryWidget({required this.roundInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5.h),
        Expanded(
          flex: 8,
          child: ShotEntry(
            roundInfo: roundInfo,
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  side: MaterialStateProperty.all(
                    BorderSide(width: 1.w, color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  await HapticFeedback.lightImpact();

                  //Save the last data entry //Add/Update shot
                  await BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                          context)
                      .addOrUpdateShot(
                    context,
                    showLastGameSavedSnakbar: true,
                  );
                  await BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                          context)
                      .previousHole(context: context, roundInfo: roundInfo);
                },
                child: const Text('Previous Hole'),
              ),

              // const HoleName(),
              HoleDropDown(
                roundInfo: roundInfo,
              ),
              OutlinedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  side: MaterialStateProperty.all(
                    BorderSide(width: 1.w, color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  await HapticFeedback.lightImpact();

                  //Save the last data entry //Add/Update shot
                  await BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                          context)
                      .addOrUpdateShot(
                    context,
                    showLastGameSavedSnakbar: true,
                  );
                  await BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                          context)
                      .nextHole(context: context, roundInfo: roundInfo);
                },
                child: const Text('Next Hole'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HoleName extends StatelessWidget {
  const HoleName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<HoleCounterCubit, HoleCounterState>(
        builder: (context, counterstate) {
          return Container(
            height: 50.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(6.r)),
              color: Colors.transparent,
            ),
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Text(
              'Hole ${counterstate.currentHole}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          );
        },
      );
}

class HoleDropDown extends StatefulWidget {
  final RoundInfo roundInfo;
  const HoleDropDown({required this.roundInfo});

  @override
  State<HoleDropDown> createState() => _HoleDropDownState();
}

class _HoleDropDownState extends State<HoleDropDown> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Constants.boxBgColor,
      ),
      child: BlocBuilder<HoleListCubit, HoleListState>(
        builder: (context, listState) {
          return BlocBuilder<HoleCounterCubit, HoleCounterState>(
            builder: (context, counterstate) {
              return Container(
                height: 50.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(6.r)),
                  color: Colors.transparent,
                ),
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: DropdownButton<String>(
                  alignment: Alignment.center,
                  value: counterstate.currentHole,
                  icon: const SizedBox.shrink(),
                  // iconSize: 24.sp,
                  // elevation: 16,
                  style: TextStyle(
                    // color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    letterSpacing: 1.2,
                  ),
                  underline: Container(height: 0),
                  onChanged: (String? newValue) async {
                    //Save the last data entry //Add/Update shot
                    // await BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                    //         context)
                    //     .addOrUpdateShot(
                    //   context,
                    //   showLastGameSavedSnakbar: true,
                    // );
                    BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                        .onNewHoleSelected(
                      context,
                      roundInfo: widget.roundInfo,
                      newHole: newValue ?? '1',
                    );
                  },
                  items: listState.holeNumberList
                      .map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                        ),
                        child: Text('Hole $value'),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
