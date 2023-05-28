import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/golfer/widgets/user_profile_image.dart';
import 'package:shot_locker/base/logic/go_to_home/go_to_home_cubit.dart';

class CustomAppBar extends StatelessWidget {
  final Widget centreWidget;
  final bool showProfileImage;
  const CustomAppBar({
    Key? key,
    required this.centreWidget,
    this.showProfileImage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!showProfileImage)
          Flexible(
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.adaptive.arrow_back),
            ),
          ),
        if (showProfileImage)
          Flexible(
            child: InkWell(
              onTap: () async =>
                  //Go to Golfer page
                  await BlocProvider.of<GoToHomeCubit>(context)
                      .goToIndex(index: 3),
              child: IgnorePointer(
                child: UserProfileImage(
                  circleRadius: 20.r,
                  allowChangeProfile: false,
                ),
              ),
            ),
          ),
        Expanded(flex: 3, child: centreWidget),
      ],
    );
  }
}
