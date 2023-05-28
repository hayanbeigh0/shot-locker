part of 'profileimage_cubit.dart';

abstract class ProfileimageState extends Equatable {
  const ProfileimageState();

  @override
  List<Object> get props => [];
}

class ProfileimageInitial extends ProfileimageState {}

class UserProfileImagePicked extends ProfileimageState {
  final File pickedImage;
  const UserProfileImagePicked({
    required this.pickedImage,
  });
  @override
  List<Object> get props => [pickedImage];
}
