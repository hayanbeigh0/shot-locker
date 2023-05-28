// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/logic/round_info.dart';
import 'package:shot_locker/base/new-round/logic/rounds_data_entry_manager/rounds_data_entry_manager_dart_cubit.dart';
import 'package:shot_locker/base/new-round/screens/new_round_screen.dart';
import 'package:shot_locker/base/new-round/widgets/rounds-entry/select_hole_type_widget.dart';
import 'package:shot_locker/base/new-round/widgets/show_dialog_content_widget.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';

class SelectHoleTypeScreen extends StatefulWidget {
  static const routeName = 'select_holeType_screen';
  final RoundInfo roundInfo;
  const SelectHoleTypeScreen({required this.roundInfo});

  @override
  State<SelectHoleTypeScreen> createState() => _SelectHoleTypeScreenState();
}

class _SelectHoleTypeScreenState extends State<SelectHoleTypeScreen> {
  String course = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      course = context.read<RoundsDataEntryManagerDartCubit>().courseName;
      log('Courses : $course');
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(top: deviceSize.height * 0.01),
          child: Text(
            'Select number of holes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
            ),
          ),
        ),
      ),
      body: ShotLockerBackgroundTheme(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_golf, size: 60.sp),
          SizedBox(height: deviceSize.height * 0.05),
          SelectHoleTypeWidget(
            selectedOption:
                BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                    .holeType,
            showDialogHeading: 'Number of holes',
            showDialogContents: const [
              ShowDialogContentWidget(title: '9 Holes'),
              ShowDialogContentWidget(title: '18 Holes'),
            ],
            onValueSelected: (selectedValue) {
              if (selectedValue == '9 Holes') {
                widget.roundInfo.setHoles(9);
              } else if (selectedValue == '18 Holes') {
                widget.roundInfo.setHoles(18);
              }
              //Update the round data entry cubit variable
              BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                  .setHoleType(holeType: selectedValue);
            },
          ),
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.arrow_forward_ios_outlined, size: 28.sp),
        onPressed: () async {
          if (await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
              .createNewGameEntry(context: context)) {
            await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                .savedCoursePrefilledHoleDetails(widget.roundInfo);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return NewRoundScreen(roundInfo: widget.roundInfo);
            }));
          }
          return;
        },
      ),
    );
  }
}
