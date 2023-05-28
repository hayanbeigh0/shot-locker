// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_version/new_version.dart';
import 'package:shot_locker/authentication/logic/authentication/authentication_bloc.dart';
import 'package:shot_locker/authentication/screen/auth_screen.dart';
import 'package:shot_locker/base/golfer/logic/user_profile/user_profile_bloc.dart';
import 'package:shot_locker/base/locker_room/logic/round_manager/round_manager_cubit.dart';
import 'package:shot_locker/base/locker_room/widgets/locker_room.dart';
import 'package:shot_locker/constants/constants.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';
import 'package:shot_locker/utility/custom_appbar.dart';
import 'package:shot_locker/utility/loading_indicator.dart';

class DashBoardScreen extends StatefulWidget {
  static const routeName = 'dash_board_screen';

  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectedIndex = 0;

  Future<void> _fetchAndRefreshHomeData(BuildContext context) async {
    BlocProvider.of<RoundManagerCubit>(context)
        .onRefreshFetchData(context: context);
    BlocProvider.of<UserProfileBloc>(context).add(
      UserProfileDetailsFetch(context: context),
    );
  }

  routeToAuthScreen() {
    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
    Navigator.of(context).pushNamed(AuthScreen.routeName);
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: 'com.credicxo.shotlocker',
      iOSId: 'com.credicxo.shotLocker',
    );
    final status = await newVersion.getVersionStatus();
    log('Status : ${status!.localVersion}');
    log('Status : ${status.localVersion.runtimeType}');

    if (status.localVersion == status.storeVersion) {
      return log('Same version');
    } else {
      newVersion.showAlertIfNecessary(context: context);
    }

    // if (status.localVersion == status.storeVersion) {
    //   return log('Same version');
    // } else {
    //   log('Status : ${status.localVersion}');
    //   log('Status : ${status.localVersion.runtimeType}');

    // newVersion.showUpdateDialog(
    //   context: context,
    //   versionStatus: status,
    //   dialogText: 'Please update the app from '
    //       '${status.localVersion} to ${status.storeVersion}',
    //   dismissAction: () {
    //     Navigator.of(context).pop();
    //   },
    // );
    // }
  }

  @override
  void initState() {
    super.initState();
    _fetchAndRefreshHomeData(context);

    _checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShotLockerBackgroundTheme(
        child: SafeArea(
          child: RefreshIndicator(
            color: Colors.white,
            onRefresh: () => _fetchAndRefreshHomeData(context),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: SingleChildScrollView(
                child: BlocBuilder<RoundManagerCubit, RoundManagerState>(
                  builder: (context, state) {
                    if (state is RoundDataLoadFailed) {
                      return const Text('Something went wrong');
                    } else if (state is RoundDataFetched) {
                      return Column(
                        children: [
                          SizedBox(height: 10.h),
                          CustomAppBar(
                            centreWidget: Padding(
                              padding: EdgeInsets.only(left: 50.w),
                              child: DropdownButton<String>(
                                dropdownColor: Constants.boxBgColor,
                                value:
                                    BlocProvider.of<RoundManagerCubit>(context)
                                        .selectedRoundHeading,
                                // icon: Icon(Icons.settings),
                                alignment: Alignment.center,
                                elevation: 16,
                                style: GoogleFonts.nunito(
                                  color: Colors.deepPurple,
                                ),
                                underline: Container(
                                  height: 0.5.h,
                                  color: Colors.transparent,
                                ),
                                items:
                                    BlocProvider.of<RoundManagerCubit>(context)
                                        .roundHeading
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          value,
                                          style: GoogleFonts.nunito(
                                            fontSize: 17.sp,
                                            color: Colors.white,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        const Divider(color: Colors.white60)
                                      ],
                                    ),
                                  );
                                }).toList(),
                                borderRadius: BorderRadius.circular(15.r),
                                onChanged: (String? newValue) async {
                                  setState(() {
                                    _selectedIndex =
                                        BlocProvider.of<RoundManagerCubit>(
                                                context)
                                            .roundHeading
                                            .indexOf(newValue!);
                                  });
                                  await BlocProvider.of<RoundManagerCubit>(
                                          context)
                                      .setRound(
                                    index: _selectedIndex,
                                    context: context,
                                  );

                                  //Check if the selected index is the last index of the list or not
                                  //if it is the last, i.e: 'Select round', change the dialog last name to Select All
                                  if (_selectedIndex ==
                                      BlocProvider.of<RoundManagerCubit>(
                                                  context)
                                              .roundHeading
                                              .length -
                                          1) {
                                    await showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return StatefulBuilder(
                                            builder: (dialogContext, setState) {
                                          return AlertDialog(
                                            backgroundColor:
                                                Constants.boxBgColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              side: const BorderSide(
                                                  color: Colors.white),
                                            ),
                                            title: Text(
                                              BlocProvider.of<
                                                          RoundManagerCubit>(
                                                      context)
                                                  .roundHeading
                                                  .last,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.sp,
                                              ),
                                            ),
                                            content: SizedBox(
                                              height: (BlocProvider.of<
                                                                  RoundManagerCubit>(
                                                              context)
                                                          .roundPlayed
                                                          .length <
                                                      4)
                                                  ? 180.h
                                                  : 250.h,
                                              width: 5.w,
                                              child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount: BlocProvider.of<
                                                              RoundManagerCubit>(
                                                          context)
                                                      .roundPlayed
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return CheckboxListTile(
                                                      checkColor: Colors.black,
                                                      title: Text(
                                                        index == 0
                                                            ? 'Select All'
                                                            : '${BlocProvider.of<RoundManagerCubit>(context).roundPlayed[index].golfName} (${BlocProvider.of<RoundManagerCubit>(context).roundPlayed[index].entryDate})',
                                                      ),
                                                      value: BlocProvider.of<
                                                                  RoundManagerCubit>(
                                                              context)
                                                          .roundPlayed[index]
                                                          .isChecked,
                                                      onChanged: (value) async {
                                                        if (value!) {
                                                          await BlocProvider.of<
                                                                      RoundManagerCubit>(
                                                                  context)
                                                              .setRoundAsChecked(
                                                                  index: index);
                                                        } else {
                                                          await BlocProvider.of<
                                                                      RoundManagerCubit>(
                                                                  context)
                                                              .setRoundAsUnChecked(
                                                                  index: index);
                                                        }
                                                        setState(() {});
                                                        return;
                                                      },
                                                    );
                                                  }),
                                            ),
                                            actions: [
                                              OutlinedButton(
                                                style: TextButton.styleFrom(
                                                  primary: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(dialogContext)
                                                      .pop();
                                                },
                                                child: const Text('Back'),
                                              ),
                                              OutlinedButton(
                                                style: TextButton.styleFrom(
                                                  primary: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(dialogContext)
                                                      .pop();
                                                  BlocProvider.of<
                                                              RoundManagerCubit>(
                                                          context)
                                                      .fetchSelectedRoundData(
                                                          context: context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        });
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          const LockerRoom(),
                        ],
                      );
                    } else if (state is TokenFail) {
                      return routeToAuthScreen();
                    } else if (state is RoundDataEmptyState) {
                      return const LockerRoom();
                    } else {
                      return const LoadingIndicator();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
