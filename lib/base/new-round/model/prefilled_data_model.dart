import 'package:shot_locker/base/new-round/util/penalty_enum.dart';

class PrefilledDataModel {
  final String startDistance;
  final String surface;
  final PenaltyType penalty;

  PrefilledDataModel({
    required this.startDistance,
    required this.surface,
    required this.penalty,
  });

  factory PrefilledDataModel.fromMap(Map<String, dynamic> map) {
    return PrefilledDataModel(
      startDistance: map['distance'] ?? '',
      surface: map['surface'] == 'X' ? 'Recovery' : map['surface'] ?? '',
      penalty: map['penalty']?.toInt() == 2
          ? PenaltyType.doublePenalty
          : map['penalty']?.toInt() == 1
              ? PenaltyType.penalty
              : PenaltyType.noPenalty,
    );
  }
}