import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/authentication/logic/authentication/authentication_bloc.dart';
import 'package:shot_locker/base/golfer/logic/user_profile/user_profile_bloc.dart';
import 'package:shot_locker/base/golfer/screen/profile_setting_screen.dart';
import 'package:shot_locker/base/golfer/widgets/faqs_screen.dart';
import 'package:shot_locker/base/golfer/widgets/terms_of_use.dart';
import 'package:shot_locker/base/golfer/widgets/user_profile_image.dart';
import 'package:shot_locker/base/logic/go_to_home/go_to_home_cubit.dart';
import 'package:shot_locker/config/.env.dart';
import 'package:shot_locker/utility/show_snak_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '/constants/constants.dart';
import 'package:http/http.dart' as http;

class GolferScreen extends StatelessWidget {
  const GolferScreen({Key? key}) : super(key: key);

  Future<void> logoutDialog({required BuildContext context}) async {
    await showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.white),
        ),
        backgroundColor: Constants.boxBgColor,
        title: const Text(
          'Logout of Shot Locker?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        children: [
          const Divider(color: Colors.white),
          SimpleDialogOption(
            onPressed: () {
              //1st pop to close the AlertDialog box
              Navigator.of(context).pop();
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
            child: const Text(
              'Logout',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(color: Colors.white),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
              return;
            },
            child: const Text(
              'Cancel',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
    return;
  }

  Future<void> deleteAccountDialog(
      {required BuildContext context, required String email}) async {
    await showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.white),
        ),
        backgroundColor: Constants.boxBgColor,
        title: const Text(
          'Are you sure you want to delete these account?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        children: [
          const Divider(color: Colors.white),
          SimpleDialogOption(
            onPressed: () async {
              log('Email : $email');
              await http.post(
                Uri.parse('https://shot-locker.com/api/account/delete-user'),
                body: {
                  'email': email,
                },
              );
              Navigator.of(context).pop();
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
            child: const Text(
              'Yes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(color: Colors.white),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
              return;
            },
            child: const Text(
              'No',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
    return;
  }

  Future<bool> willPopScope(BuildContext context) async {
    await BlocProvider.of<GoToHomeCubit>(context).goToHome();
    //Return false to not to close the app when the back button will triggered.
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // final _deviceSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => willPopScope(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text(
            'Golfer',
            style: TextStyle(
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: Container(
          decoration: Constants.gradientBackground,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: ListView(
                children: [
                  SizedBox(height: 30.h),
                  Center(
                    child: UserProfileImage(
                      circleRadius: 55.r,
                      allowChangeProfile: false,
                      fromGolferScreen: true,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 14.w,
                    ),
                    child: Text(
                      'SETTINGS',
                      style: TextStyle(
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: Column(
                        children: [
                          SettingTile(
                            label: 'Profile Settings',
                            onTap: () async {
                              await Navigator.of(context)
                                  .pushNamed(ProfileSettingScreen.routeName);
                            },
                          ),
                          // SettingTile(
                          //   label: 'My Bag',
                          //   onTap: () {},
                          // ),
                          // SettingTile(
                          //   label: 'Subscription',
                          //   onTap: () {},
                          // ),
                          // SettingTile(
                          //   label: 'Ad Preferences',
                          //   onTap: () {},
                          // ),
                          // SettingTile(
                          //   label: 'Siri Shortcuts',
                          //   onTap: () {},
                          // ),
                          SettingTile(
                            label: 'Logout',
                            onTap: () async {
                              //to vibrate the phone
                              await HapticFeedback.heavyImpact();
                              await logoutDialog(context: context);
                            },
                          ),
                          BlocBuilder<UserProfileBloc, UserProfileState>(
                            builder: (context, state) {
                              if (state is UserProfileDataFetched) {
                                return SettingTile(
                                  label: 'Delete Account',
                                  onTap: () async {
                                    //to vibrate the phone
                                    await HapticFeedback.heavyImpact();
                                    await deleteAccountDialog(
                                        context: context,
                                        email:
                                            state.userProfileFetchModel.email);
                                  },
                                );
                              } else {
                                return const Text(
                                  'Error occured',
                                  style: TextStyle(
                                    letterSpacing: 1.2,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 27.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 14.w,
                    ),
                    child: Text(
                      'SUPPORT',
                      style: TextStyle(
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: Column(
                        children: [
                          SettingTile(
                            label: 'FAQs',
                            onTap: () => Navigator.of(context)
                                .pushNamed(FAQsScreen.routeName),
                          ),
                          SettingTile(
                            label: 'Terms Of User',
                            onTap: () => Navigator.of(context)
                                .pushNamed(TermsOfUse.routeName),
                          ),
                          SettingTile(
                            label: 'Follow us on Instagram',
                            onTap: () async {
                              await canLaunch(instagramLink)
                                  ? launch(instagramLink)
                                  : ShowSnackBar.showSnackBar(
                                      context,
                                      'Error occured !',
                                      backGroundColor: Colors.red,
                                    );
                            },
                          ),
                          // SettingTile(
                          //   label: 'Rate us on the App Store',
                          //   onTap: () {},
                          // ),
                          // SettingTile(
                          //   label: 'Invite Friends',
                          //   onTap: () {},
                          // ),
                          // SettingTile(
                          //   label: 'Blog',
                          //   onTap: () {},
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SettingTile({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.white38,
          ),
        ],
      ),
    );
  }
}
