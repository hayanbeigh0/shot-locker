// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/constants/constants.dart';

class ShowDialogContentWidget extends StatelessWidget {
  final String title;

  const ShowDialogContentWidget({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await HapticFeedback.lightImpact();
        //After the user click one of the option, then close the dialog with the selected name
        Navigator.of(context).pop(title);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10.r),
            color: Constants.boxBgColor,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          width: double.infinity,
          child: Text(title),
        ),
      ),
    );
  }
}
