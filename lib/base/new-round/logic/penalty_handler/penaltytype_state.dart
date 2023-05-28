part of 'penaltytype_cubit.dart';

class PenaltytypeState extends Equatable {
  final PenaltyType currentPenaltyType;
  const PenaltytypeState({
    required this.currentPenaltyType,
  });
  PenaltytypeState copyWith({PenaltyType? currentPenaltyType}) =>
      PenaltytypeState(
          currentPenaltyType: currentPenaltyType ?? this.currentPenaltyType);
  @override
  List<Object> get props => [currentPenaltyType];
}
