// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/logic/round_info.dart';
import 'package:shot_locker/base/new-round/screens/round_entry_screens/select_hole_type_screen.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';
import '../../../../config/token_shared_pref.dart';

class SelectTee extends StatefulWidget {
  final int courseId;
  final RoundInfo roundInfo;
  const SelectTee({required this.courseId, required this.roundInfo});

  @override
  State<SelectTee> createState() => _SelectTeeState();
}

class _SelectTeeState extends State<SelectTee> {
  late List<dynamic> list;
  late int number = 3;
  bool load = true;

  Future<void> getTees() async {
    final token = await TokenSharedPref().fetchStoredToken();
    // print(token.token);

    Response response = await Dio()
        .get('https://shot-locker.com/api/shot/tees-list/${widget.courseId}',
            options: Options(
              headers: {
                'Authorization': 'Bearer ${token.token}',
              },
            ));
    list = response.data;
    number = list.length;
// print(jsonDecode(list[0])['tee']);
    setState(() {
      load = false;
    });
// print(number);
  }

  @override
  void initState() {
    getTees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    if (load == true) {
      return const SpinKitFadingCircle(
        color: Colors.white,
        size: 50.0,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(top: deviceSize.height * 0.01),
            child: Text(
              'Select Tee',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
          ),
        ),
        body: ShotLockerBackgroundTheme(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.golf_course_rounded, size: 60.sp),
              SizedBox(height: deviceSize.height * 0.05),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: number,
                  itemBuilder: (context, index) {
                    return textWidget(
                      title: list[index]['tee'],
                      id: list[index]['id'],
                      roundInfo: widget.roundInfo,
                    );
                  })
            ],
          ),
        )),
      );
    }
  }
}

class textWidget extends StatelessWidget {
  final String title;
  final int id;
  final RoundInfo roundInfo;
  const textWidget(
      {required this.title, required this.id, required this.roundInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            roundInfo.setTee(id);
            await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return SelectHoleTypeScreen(roundInfo: roundInfo);
            }));
          },
          child: Container(
            color: const Color(0xff1a252c),
            height: 50.h,
            width: 300.w,
            child: Center(
                child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
          ),
        ),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }
}
