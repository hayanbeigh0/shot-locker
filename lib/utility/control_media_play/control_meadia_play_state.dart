part of 'control_meadia_play_cubit.dart';

abstract class ControlMeadiaPlayState extends Equatable {
  const ControlMeadiaPlayState();

  @override
  List<Object> get props => [];
}

class ControlMeadiaPlayInitial extends ControlMeadiaPlayState {}

class ControlMeadiaPlayLoading extends ControlMeadiaPlayState {}

class StopMediaPlay extends ControlMeadiaPlayState {}
