part of 'shot_counter_cubit.dart';

 class ShotCounterState extends Equatable {
  final int currentShot;
  const ShotCounterState({
    required this.currentShot,
  });
  ShotCounterState copyWith({int? currentShot}) =>
      ShotCounterState(currentShot: currentShot ?? this.currentShot);
  @override
  List<Object> get props => [currentShot];
}
