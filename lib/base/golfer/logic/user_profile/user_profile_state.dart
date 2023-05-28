part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileDataFetched extends UserProfileState {
  final UserProfileFetchModel userProfileFetchModel;
  const UserProfileDataFetched({
    required this.userProfileFetchModel,
  });

  @override
  List<Object> get props => [userProfileFetchModel];
}

class UserProfileDataFetchFailed extends UserProfileState {}

class UserProfileDataUpdated extends UserProfileState {}
