import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200.h,
          width: 250.w,
          child: Image.asset(
            'assets/shot_locker-without_bg.png',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
