import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/golfer/logic/profile_image/profileimage_cubit.dart';
import 'package:shot_locker/base/golfer/logic/user_profile/user_profile_bloc.dart';
import 'package:shot_locker/base/golfer/screen/profile_setting_screen.dart';

class UserProfileImage extends StatelessWidget {
  final double circleRadius;
  final bool allowChangeProfile;
  final bool fromGolferScreen;
  const UserProfileImage({
    Key? key,
    required this.circleRadius,
    this.allowChangeProfile = true,
    this.fromGolferScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        if (state is UserProfileDataFetched) {
          return Stack(children: [
            BlocBuilder<ProfileimageCubit, ProfileimageState>(
              builder: (context, profileImageState) {
                if (profileImageState is UserProfileImagePicked) {
                  return CircleAvatar(
                      radius: circleRadius,
                      backgroundImage:
                          const AssetImage('assets/empty_profile.png'),
                      backgroundColor: Colors.grey.shade300,
                      foregroundImage:
                          FileImage(profileImageState.pickedImage));
                } else {
                  return CircleAvatar(
                    radius: circleRadius,
                    backgroundImage:
                        const AssetImage('assets/empty_profile.png'),
                    backgroundColor: Colors.grey.shade300,
                    foregroundImage: state.userProfileFetchModel.photo.isEmpty
                        ? const AssetImage('assets/empty_profile.png')
                            as ImageProvider
                        : CachedNetworkImageProvider(
                            state.userProfileFetchModel.photo,
                          ),
                  );
                }
              },
            ),
            if (allowChangeProfile ||
                (state.userProfileFetchModel.photo.isEmpty && fromGolferScreen))
              Positioned(
                bottom: 0.h,
                right: 0.w,
                child: InkWell(
                  onTap: () async {
                    await HapticFeedback.lightImpact();
                    if (fromGolferScreen) {
                      await Navigator.of(context)
                          .pushNamed(ProfileSettingScreen.routeName);
                    } else {
                      await BlocProvider.of<ProfileimageCubit>(context)
                          .pickProfileimage(context);
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20.r,
                    child: CircleAvatar(
                      radius: 18.r,
                      child: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ),
              ),
          ]);
        } else {
          return CircleAvatar(
            radius: circleRadius,
            backgroundImage: const AssetImage(
              'assets/empty_profile.png',
            ),
            backgroundColor: Colors.grey.shade300,
          );
        }
      },
    );
  }
}
