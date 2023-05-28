import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/new-round/logic/rounds_data_entry_manager/rounds_data_entry_manager_dart_cubit.dart';
import 'package:shot_locker/base/new-round/screens/round_entry_screens/select_course_screen.dart';
import 'package:shot_locker/base/new-round/widgets/rounds-entry/table_calendar_widget.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';

class SelectDateScreen extends StatelessWidget {
  static const routeName = 'select_date_screen';

  const SelectDateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Select Date',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: ShotLockerBackgroundTheme(
          child: TableCalendarWidget(
        firstDay: DateTime(2022, 1, 1),
        lastDay: DateTime.now(),
        onDateSelected: ((selectedDate) async {
          await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
              .setDate(selectedDate: selectedDate);
        }),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.arrow_forward_ios_outlined, size: 28.sp),
        onPressed: () async {
          BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
              .fetchCourseList(context: context);
          await Navigator.of(context).pushNamed(SelectCourseScreen.routeName);
        },
      ),
    );
  }
}
