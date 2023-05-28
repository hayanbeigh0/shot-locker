part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class UserProfileDetailsFetch extends UserProfileEvent {
  final BuildContext context;
  const UserProfileDetailsFetch({
    required this.context,
  });
}

class UpdateUserProfile extends UserProfileEvent {
  final UserProfileFetchModel userProfileFetchModel;
  final bool isProfileImagePicked;
  final File? pickedProfileImage;
  final BuildContext context;
  const UpdateUserProfile({
    required this.userProfileFetchModel,
    required this.isProfileImagePicked,
    this.pickedProfileImage,
    required this.context,
  });
}

class UpdateUserProfileImage extends UserProfileEvent {
  final BuildContext context;
  const UpdateUserProfileImage({
    required this.context,
  });
}
