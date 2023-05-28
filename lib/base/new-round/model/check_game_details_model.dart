import 'package:shot_locker/base/new-round/util/penalty_enum.dart';

class CheckGameDetailsModel {
  final bool isGameFinished;
  final int gameId;
  final int shotId;
  final String holeType;
  final String hole;
  final int lastShot;
  final String startDistance;
  final String surface;
  final PenaltyType penalty;
  CheckGameDetailsModel({
    required this.isGameFinished,
    required this.gameId,
    required this.shotId,
    required this.holeType,
    required this.hole,
    required this.lastShot,
    required this.startDistance,
    required this.surface,
    required this.penalty,
  });

  factory CheckGameDetailsModel.fromMap(Map<String, dynamic> map) {
    return CheckGameDetailsModel(
      isGameFinished: map['status'] ?? false,
      gameId: map['game']?.toInt() ?? 0,
      shotId: map['shot_id']?.toInt() ?? 0,
      holeType: map['hole_type'] ?? '',
      hole: map['hole'] ?? '',
      lastShot: map['last_shot']?.toInt() ?? 0,
      startDistance: map['start_distance'] ?? '',
      surface: map['surface'] == 'X' ? 'Recovery' : map['surface'] ?? '',
      penalty: map['penalty']?.toInt() == 2
          ? PenaltyType.doublePenalty
          : map['penalty']?.toInt() == 1
              ? PenaltyType.penalty
              : PenaltyType.noPenalty,
    );
  }

  factory CheckGameDetailsModel.fromJson(dynamic source) =>
      CheckGameDetailsModel.fromMap(source);
}
