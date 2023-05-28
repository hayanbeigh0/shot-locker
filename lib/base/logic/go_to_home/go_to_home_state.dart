part of 'go_to_home_cubit.dart';

abstract class GoToHomeState extends Equatable {
  const GoToHomeState();

  @override
  List<Object> get props => [];
}

class GoToHomeInitial extends GoToHomeState {}

class GoToHomeTriggered extends GoToHomeState {
  @override
  List<Object> get props => [];
}

class GoToSelectedPage extends GoToHomeState {
  final int index;
  const GoToSelectedPage({required this.index});

  @override
  List<Object> get props => [];
}
