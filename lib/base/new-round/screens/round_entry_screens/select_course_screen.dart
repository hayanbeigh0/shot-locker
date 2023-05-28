// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shot_locker/base/logic/round_info.dart';
import 'package:shot_locker/base/new-round/logic/rounds_data_entry_manager/rounds_data_entry_manager_dart_cubit.dart';
import 'package:shot_locker/base/new-round/model/course_list_model.dart';
import 'package:shot_locker/base/new-round/screens/round_entry_screens/select_hole_type_screen.dart';
import 'package:shot_locker/base/new-round/screens/round_entry_screens/select_tees_screen.dart';
import 'package:shot_locker/constants/constants.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';
import 'package:shot_locker/utility/loading_indicator.dart';

class SelectCourseScreen extends StatefulWidget {
  static const routeName = 'select_course_screen';

  const SelectCourseScreen({Key? key}) : super(key: key);

  @override
  State<SelectCourseScreen> createState() => _SelectCourseScreenState();
}

class _SelectCourseScreenState extends State<SelectCourseScreen> {
  final _courseSelectTextController = TextEditingController();
  final GlobalKey<FormState> _courseTextFieldKey = GlobalKey();
  String _queryText = '';
  late FocusNode suggestionFocusNode;
  late FocusNode addCourseFocusNode;
  late int id = 0;
  late RoundInfo roundInfo = RoundInfo();
  bool addCourse = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    suggestionFocusNode = FocusNode();
    addCourseFocusNode = FocusNode();

    // BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
    //     .fetchCourseList(context: context);
    super.initState();
  }

  courseSelectTextField() => TypeAheadFormField<CourseWithDistanceListModel>(
        autoFlipDirection: true,
        key: const ValueKey('selectCourse'),
        direction: AxisDirection.up,
        textFieldConfiguration: TextFieldConfiguration(
          focusNode: suggestionFocusNode,
          controller: _courseSelectTextController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            // labelText: 'Search courses',
            hintText: 'Search courses...',
            contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Field can't be empty";
          } else {
            return null;
          }
        },
        suggestionsCallback: (query) async {
          _queryText = query;
          log('Query : $query');
          return await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
              .getSearchedCourseSuggestions(query);
        },
        onSuggestionSelected: (selectedData) async {
          _courseSelectTextController.text = selectedData.courseName.trim();
          //Update the round data entry cubit variable
          id = selectedData.id;
          roundInfo.setCourse(id);
          await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
              .setCourseName(courseName: _courseSelectTextController.text);
        },
        loadingBuilder: (_) => Container(
          color: Constants.boxBgColor,
          child: const LoadingIndicator(),
        ),
        itemBuilder: (context, snapshot) {
          return ListTile(
            leading: const Icon(Icons.golf_course),
            title: Text(snapshot.courseName),
            trailing: snapshot.distance.isNotEmpty
                ? Text('${snapshot.distance} kms')
                : const SizedBox.shrink(),
            tileColor: Constants.boxBgColor,
          );
        },
        noItemsFoundBuilder: (context) {
          if (_queryText.isNotEmpty) {
            BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                .setCourseName(courseName: _queryText);
          }
          return Container(
            width: double.infinity,
            color: Constants.boxBgColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No course found, press the green arrow button to save the course and proceed.',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          );
        },
      );
  addcourseTextField() => TextFormField(
        key: const ValueKey('addCourse'),
        controller: _courseSelectTextController,
        focusNode: addCourseFocusNode,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          // labelText: 'Add new course',
          hintText: 'Enter the course name',
          contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
        onChanged: (value) async {
          //Update the round data entry cubit variable
          log(value.toString());
          await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
              .setCourseName(courseName: value.trim());
          await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
              .getCourseName(value.trim());
        },
        onFieldSubmitted: (value) async {
          //Update the round data entry cubit variable
          log(value.toString());
          await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
              .setCourseName(courseName: value.trim());
          await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
              .getCourseName(value.trim());
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "Field can't be empty";
          } else {
            return null;
          }
        },
      );

  mySavedCourses() => OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
          ),
          child: const Text(
            'My saved courses',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () async {
          addCourseFocusNode.unfocus();
          suggestionFocusNode.unfocus();
          await HapticFeedback.lightImpact();
          final savedCourseList =
              await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                  .getSavedCourseSuggestions();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Constants.boxBgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: const BorderSide(color: Colors.white),
                ),
                content: SizedBox(
                  height: savedCourseList.isEmpty ? 150.h : 300.h,
                  width: 5.w,
                  child: savedCourseList.isEmpty
                      ? Container(
                          color: Constants.boxBgColor,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No saved course found.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                OutlinedButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'OK',
                                  ),
                                )
                              ]),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: savedCourseList[0].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: InkWell(
                                onTap: () async {
                                  // print(index);
                                  Navigator.of(context).pop();
                                  _courseSelectTextController.text =
                                      savedCourseList[0][index];
                                  id = int.parse(savedCourseList[1][index]);
                                  await BlocProvider.of<
                                              RoundsDataEntryManagerDartCubit>(
                                          context)
                                      .setCourseName(
                                    courseName:
                                        _courseSelectTextController.text,
                                  );
                                },
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(Icons.golf_course),
                                  title: Text(savedCourseList[0][index]),
                                  tileColor: Constants.boxBgColor,
                                ),
                              ),
                            );
                          },
                        ),
                ),
                actions: [
                  Align(
                    alignment: Alignment.center,
                    child: OutlinedButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Back'),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );

  courseSelectorSwitch() => OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
          ),
          child: Text(
            addCourse ? 'Select suggestion course' : 'Add new course',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () async {
          await HapticFeedback.lightImpact();
          setState(() {
            addCourse = !addCourse;
          });
          if (addCourse) {
            addCourseFocusNode.requestFocus();
          } else {
            suggestionFocusNode.requestFocus();
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Select Course',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: ShotLockerBackgroundTheme(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.golf_course, size: 60.sp),
            SizedBox(height: 40.h),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: Text(
                addCourse ? 'Add new course' : 'Search courses',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: Form(
                key: _courseTextFieldKey,
                child:
                    addCourse ? addcourseTextField() : courseSelectTextField(),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: SizedBox(
                width: double.infinity,
                child: mySavedCourses(),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: SizedBox(
                width: double.infinity,
                child: courseSelectorSwitch(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.arrow_forward_ios_outlined, size: 28.sp),
        onPressed: () async {
          if (!_courseTextFieldKey.currentState!.validate()) {
            return;
          } else {
            if (id != 0) {
              _courseTextFieldKey.currentState!.save();
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return SelectTee(
                  courseId: id,
                  roundInfo: roundInfo,
                );
              }));
              return;
            } else {
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return SelectHoleTypeScreen(roundInfo: roundInfo);
              }));
            }
          }
        },
      ),
    );
  }
}
