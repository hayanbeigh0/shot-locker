part of 'hole_counter_cubit.dart';

class HoleCounterState extends Equatable {
  final String currentHole;
  const HoleCounterState({
    required this.currentHole,
  });
  HoleCounterState copyWith({String? currentHole}) =>
      HoleCounterState(currentHole: currentHole ?? this.currentHole);
  @override
  List<Object> get props => [currentHole];
}
