// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/locker_room/logic/round_manager/round_manager_cubit.dart';
import 'package:shot_locker/base/logic/round_info.dart';
import 'package:shot_locker/base/new-round/logic/penalty_handler/penaltytype_cubit.dart';
import 'package:shot_locker/base/new-round/util/penalty_enum.dart';
import 'package:shot_locker/base/new-round/widgets/data_entry/result_display.dart';
import 'package:shot_locker/base/new-round/logic/rounds_data_entry_manager/rounds_data_entry_manager_dart_cubit.dart';
import 'package:shot_locker/base/new-round/widgets/data_entry/number_pad.dart';
import 'package:shot_locker/base/screen/base_screen.dart';
import 'package:shot_locker/utility/show_confirmation_dialog.dart';
import 'surface_items.dart';

class ShotEntry extends StatefulWidget {
  final RoundInfo roundInfo;
  const ShotEntry({required this.roundInfo});

  @override
  State<ShotEntry> createState() => _ShotEntryState();
}

class _ShotEntryState extends State<ShotEntry> {
  void _popAfterGameDetailsChange() {
    final roundDataEntryCubit =
        BlocProvider.of<RoundsDataEntryManagerDartCubit>(context);
    final isLastGameCompleted = roundDataEntryCubit.isLastGameCompleted;
    final isEditDetails = roundDataEntryCubit.isEditGameDetails;
    if (isLastGameCompleted && !isEditDetails) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const BaseScreen(),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final _deviceSize = MediaQuery.of(context).size;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const ResultDisplay(),
        SizedBox(height: 10.h),
        const SurfaceItems(),
        SizedBox(height: 10.h),
        NumberPad(onSelectNumber: (key) async {
          if (key.toLowerCase().contains('next') ||
              key.toLowerCase().contains('update') ||
              key.toLowerCase().contains('forward')) {
            await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                .addOrUpdateShot(
              context,
              dataValidation: true,
            );
          } else {
            await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                .onNumberSelected(
              number: key,
              context: context,
            );
          }
        }),
        SizedBox(height: 10.h),
        BlocBuilder<PenaltytypeCubit, PenaltytypeState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ExtraWidget(
                  label: 'Penalty',
                  onTap: () async {
                    await BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                            context)
                        .setPenalty(
                      selectedPenaltyType: PenaltyType.penalty,
                      context: context,
                    );
                  },
                  isSelected: state.currentPenaltyType == PenaltyType.penalty,
                ),
                ExtraWidget(
                  label: 'Out of Bounds',
                  onTap: () async {
                    await BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                            context)
                        .setPenalty(
                      selectedPenaltyType: PenaltyType.doublePenalty,
                      context: context,
                    );
                  },
                  isSelected:
                      state.currentPenaltyType == PenaltyType.doublePenalty,
                ),
                // ExtraWidget(label: 'Recovery'),
              ],
            );
          },
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            // ExtraWidget(
            //   label: 'Cancel',
            //   width: 60.0,
            //   onTap: () async {
            //     await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
            //         .resetEnteredDetails();
            //   },
            // ),
            ExtraWidget(
              label: '< Previous Shot',
              onTap: () async {
                await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                    .previousShot(context: context);
              },
            ),
            ExtraWidget(
              label: 'Scratch Remainder',
              onTap: () async {
                await HapticFeedback.lightImpact();

                //Save the last data entry //Add/Update shot
                await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                    .addOrUpdateShot(
                  context,
                  showLastGameSavedSnakbar: true,
                  isSratch: true,
                );
                log('Scratch!!');
                await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                    .scratch(context: context, roundInfo: widget.roundInfo);
              },
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            ExtraWidget(
              label: 'Finish Game',
              onTap: () async {
                if (await showConfirmationdialog(context,
                    title: 'Are you sure?',
                    actionName: 'Do you want to Finish the game?')) {
                  //Use to count the stack during popUntil

                  //Save the last data entry //Add/Update shot
                  await BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                          context)
                      .addOrUpdateShot(
                    context,
                    showLastGameSavedSnakbar: true,
                  );
                  if (await BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                          context)
                      .finishCurrentGameEntry(context: context)) {
                    //Refresh the home page data.
                    BlocProvider.of<RoundManagerCubit>(context)
                        .onRefreshFetchData(context: context);
                    _popAfterGameDetailsChange();
                  }
                }
              },
            ),
            ExtraWidget(
              label: 'Delete Game',
              onTap: () async {
                if (await showConfirmationdialog(context,
                    title: 'Are you sure?',
                    actionName: 'Do you want to Delete the game?')) {
                  //Use to count the stack during popUntil
                  if (await BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                          context)
                      .deleteCurrentGameEntry(context: context)) {
                    //Refresh the home page data.
                    BlocProvider.of<RoundManagerCubit>(context)
                        .onRefreshFetchData(context: context);
                    _popAfterGameDetailsChange();
                    if (BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                            context)
                        .isEditGameDetails) {
                      Navigator.pop(context); //Close the game details screen.
                    }
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ExtraWidget extends StatelessWidget {
  final String label;
  final void Function() onTap;
  final bool isSelected;
  final Color? backgroundColor;
  const ExtraWidget({
    Key? key,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: InkWell(
          onTap: () async {
            await HapticFeedback.lightImpact();
            onTap.call();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(6.r)),
                color: backgroundColor != null
                    ? backgroundColor!
                    : isSelected
                        ? Colors.green
                        : Colors.black,
              ),
              padding: EdgeInsets.symmetric(
                vertical: 20.h,
                horizontal: 10.w,
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  //  isSelected ? Colors.white :
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      );
}
