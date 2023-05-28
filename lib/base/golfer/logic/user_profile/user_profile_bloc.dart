import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shot_locker/base/golfer/logic/profile_image/profileimage_cubit.dart';
import 'package:shot_locker/base/golfer/model/user_profile_fetch_model.dart';
import 'package:shot_locker/base/golfer/repository/user_profile_repository.dart';
import 'package:shot_locker/config/token_shared_pref.dart';
import 'package:shot_locker/utility/loading_spinner_dialogbox.dart';
import 'package:shot_locker/utility/show_snak_bar.dart';
part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(UserProfileInitial()) {
    final _userProfileRepository = UserProfileRepository();

    on<UserProfileEvent>(
      (event, emit) async {
        final _token = await TokenSharedPref().fetchStoredToken();
        Future<void> fetchUserDetails() async {
          emit(UserProfileLoading());
          await _userProfileRepository
              .fetchUserProfileDetails(_token)
              .then((response) {
            final _userProfileFetchData =
                UserProfileFetchModel.fromJson(response.data);
            emit(
              UserProfileDataFetched(
                userProfileFetchModel: _userProfileFetchData,
              ),
            );
          });
          return;
        }

        if (event is UserProfileDetailsFetch) {
          try {
            await fetchUserDetails();
          } catch (error) {
            emit(UserProfileDataFetchFailed());
          }
        } else if (event is UpdateUserProfile) {
          var context = event.context;
          ShowDialogSpinner.showDialogSpinner(context: context);

          try {
            if (event.isProfileImagePicked) {
              await _userProfileRepository.changeUserProfilePhoto(
                _token,
                event.pickedProfileImage!,
              );
            }
            await _userProfileRepository.changeUserProfileDetails(
              _token,
              event.userProfileFetchModel,
            );
            await BlocProvider.of<ProfileimageCubit>(context)
                .clearPickedImage();
            //To close the Loading spinner
            Navigator.of(context).pop();
            //To profile setting page
            Navigator.of(context).pop();
            ShowSnackBar.showSnackBar(context, 'Profile successfully updated.');
            await fetchUserDetails();
          } catch (e) {
            //To close the Loading spinner
            Navigator.of(context).pop();
            if (e is DioError) {
              // print(e.response!.data);
              ShowSnackBar.showSnackBar(context, 'Profile update error.');
            } else {
              ShowSnackBar.showSnackBar(context, 'Profile update error.');
            }
            await fetchUserDetails();
          }
        }
      },
    );
  }
}
