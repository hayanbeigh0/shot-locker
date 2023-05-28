import 'package:shot_locker/base/new-round/util/penalty_enum.dart';

class GameDetailsModel {
  final int gameId;
  final int currentSelectedShotId;
  final int previousShotId;
  final int nextShotId;
  final int hole;
  final String startDistance;
  final String surface;
  final PenaltyType penalty;
  GameDetailsModel({
    required this.gameId,
    required this.currentSelectedShotId,
    required this.previousShotId,
    required this.nextShotId,
    required this.hole,
    required this.startDistance,
    required this.surface,
    required this.penalty,
  });

  factory GameDetailsModel.fromMap(Map<String, dynamic> map) {
    return GameDetailsModel(
      gameId: map['game']?.toInt() ?? 0,
      currentSelectedShotId: map['current_id']?.toInt() ?? 0,
      previousShotId:
          map['prev_id'] == 'Not available' ? 0 : map['prev_id'].toInt() ?? 0,
      nextShotId:
          map['next_id'] == 'Not available' ? 0 : map['next_id'].toInt() ?? 0,
      hole: int.parse(map['hole'] ?? 0),
      startDistance: map['start_distance'] ?? '',
      surface: map['surface'] == 'X' ? 'Recovery' : map['surface'] ?? '',
      penalty: map['penalty']?.toInt() == 2
          ? PenaltyType.doublePenalty
          : map['penalty']?.toInt() == 1
              ? PenaltyType.penalty
              : PenaltyType.noPenalty,
    );
  }

  factory GameDetailsModel.fromJson(dynamic source) =>
      GameDetailsModel.fromMap(source);
}
