// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/golfer/logic/profile_image/profileimage_cubit.dart';
import 'package:shot_locker/base/golfer/logic/user_profile/user_profile_bloc.dart';
import 'package:shot_locker/base/golfer/model/user_profile_fetch_model.dart';
import 'package:shot_locker/base/golfer/widgets/user_profile_image.dart';
import 'package:shot_locker/constants/constants.dart';
import 'package:shot_locker/utility/loading_indicator.dart';

class ProfileSettingScreen extends StatefulWidget {
  static const routeName = '/profile_setting_screen';

  const ProfileSettingScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  // final _dobController = TextEditingController();
  File? _pickedImage;
  Future<void> _trySubmit(
      BuildContext context, UserProfileFetchModel userProfileData) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      //to vibrate the phone
      await HapticFeedback.vibrate();
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (_) => SimpleDialog(
          backgroundColor: Constants.boxBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
            side: const BorderSide(color: Colors.white),
          ),
          title: Text(
            'Update Profile?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.sp),
          ),
          children: [
            const Divider(color: Colors.white),
            SimpleDialogOption(
              onPressed: () async {
                await HapticFeedback.lightImpact();
                // pop to close the Alert Box.
                Navigator.of(context).pop();
                BlocProvider.of<UserProfileBloc>(context).add(UpdateUserProfile(
                  userProfileFetchModel: userProfileData,
                  pickedProfileImage: _pickedImage,
                  isProfileImagePicked: _pickedImage != null,
                  context: context,
                ));
              },
              child: const Text(
                'Update',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(color: Colors.white),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                textAlign: TextAlign.center,
                // style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }
  }

  // @override
  // void dispose() {
  //   _dobController.dispose();
  //   super.dispose();
  // }

  Future<bool> willPopScope(BuildContext context) async {
    await BlocProvider.of<ProfileimageCubit>(context).clearPickedImage();
    //Return false to not to close the app when the back button will triggered.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // final _deviceSize = MediaQuery.of(context).size;
    _updateProfileButton(UserProfileFetchModel userProfileData) => SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            onPressed: () async {
              await HapticFeedback.lightImpact();
              _trySubmit(context, userProfileData);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20.h,
              ),
              child: Text(
                'Update profile',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );

    return WillPopScope(
      onWillPop: () => willPopScope(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text(
            'Profile setting',
            style: TextStyle(
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: Container(
          decoration: Constants.gradientBackground,
          child: Center(
            child: BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, state) {
                if (state is UserProfileLoading) {
                  return const LoadingIndicator();
                } else if (state is UserProfileDataFetched) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.h),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            BlocListener<ProfileimageCubit, ProfileimageState>(
                              listener: (context, state) {
                                if (state is UserProfileImagePicked) {
                                  _pickedImage = state.pickedImage;
                                } else {
                                  _pickedImage = null;
                                }
                              },
                              child: Center(
                                child: UserProfileImage(circleRadius: 55.r),
                              ),
                            ),
                            SizedBox(height: 40.h),
                            TextFormField(
                              initialValue:
                                  state.userProfileFetchModel.firstName,
                              key: const ValueKey('First Name'),
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.sentences,
                              enableSuggestions: false,
                              keyboardType: TextInputType.name,
                              autofillHints: const [AutofillHints.givenName],
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field can't be empty";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                state.userProfileFetchModel.firstName =
                                    value!.trim();
                              },
                            ),
                            SizedBox(height: 20.h),
                            TextFormField(
                              initialValue:
                                  state.userProfileFetchModel.lastName,
                              key: const ValueKey('Last Name'),
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.sentences,
                              enableSuggestions: false,
                              keyboardType: TextInputType.name,
                              autofillHints: const [AutofillHints.familyName],
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field can't be empty";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                state.userProfileFetchModel.lastName =
                                    value!.trim();
                              },
                            ),
                            SizedBox(height: 20.h),
                            TextFormField(
                              readOnly: true,
                              enabled: false,
                              initialValue: state.userProfileFetchModel.email,
                              key: const ValueKey('email'),
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.sentences,
                              enableSuggestions: false,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              style: const TextStyle(
                                fontWeight: FontWeight.w200,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field can't be empty";
                                }
                                return null;
                              },
                            ),
                            //TODO: Will require in future
                            // SizedBox(height: _deviceSize.height * 0.02),
                            // TextFormField(
                            //   key: const ValueKey('dob'),
                            //   controller: _dobController,
                            //   readOnly: true,
                            //   textInputAction: TextInputAction.next,
                            //   autocorrect: false,
                            //   textCapitalization: TextCapitalization.sentences,
                            //   enableSuggestions: false,
                            //   keyboardType: TextInputType.text,
                            //   autofillHints: const [AutofillHints.birthdayDay],
                            //   decoration: InputDecoration(
                            //     labelText: 'Date of Birth',
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //   ),
                            //   onTap: () async {
                            //     final _pickedTime = await showDatePicker(
                            //       context: context,
                            //       initialDate:
                            //           state.userProfileFetchModel.dob == ''
                            //               ? DateTime.now()
                            //               : DateTime.parse(
                            //                   state.userProfileFetchModel.dob),
                            //       firstDate: DateTime(1980, 1, 1),
                            //       lastDate: DateTime.now(),
                            //       builder: (context, child) {
                            //         return Theme(
                            //           data: ThemeData.dark().copyWith(
                            //             colorScheme: const ColorScheme.dark(
                            //               primary: Colors.white,
                            //               onPrimary: Colors.black,
                            //               surface: Colors.black,
                            //               onSurface: Colors.white,
                            //             ),
                            //             dialogBackgroundColor: Colors.black,
                            //           ),
                            //           child: child!,
                            //         );
                            //       },
                            //     );
                            //     if (_pickedTime != null) {
                            //       _dobController.text = DateFormat('yyyy-MM-dd')
                            //           .format(_pickedTime);
                            //       //Set the new value to state value
                            //       state.userProfileFetchModel.dob =
                            //           _dobController.text;
                            //     }
                            //     return;
                            //   },
                            //   validator: (value) {
                            //     if (value!.isEmpty) {
                            //       return "Field can't be empty";
                            //     }
                            //     return null;
                            //   },
                            // ),
                            // SizedBox(height: _deviceSize.height * 0.02),
                            // TextFormField(
                            //   initialValue: state.userProfileFetchModel.phone,
                            //   key: const ValueKey('phone'),
                            //   textInputAction: TextInputAction.done,
                            //   autocorrect: false,
                            //   textCapitalization: TextCapitalization.sentences,
                            //   enableSuggestions: false,
                            //   keyboardType: TextInputType.phone,
                            //   autofillHints: const [
                            //     AutofillHints.telephoneNumber
                            //   ],
                            //   decoration: InputDecoration(
                            //     labelText: 'Phone number',
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //   ),
                            //   validator: (value) {
                            //     if (value!.isEmpty) {
                            //       return "Field can't be empty";
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     state.userProfileFetchModel.phone =
                            //         value!.trim();
                            //   },
                            // ),
                            SizedBox(height: 20.h),
                            _updateProfileButton(state.userProfileFetchModel),
                          ],
                        ),
                      ),
                    ),
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
          ),
        ),
      ),
    );
  }
}
