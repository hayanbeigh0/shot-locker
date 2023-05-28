import 'package:shot_locker/base/new-round/util/penalty_enum.dart';

class EditGameDetailsList {
  final List<EditGameDetailsModel> editGameDetailsList;
  EditGameDetailsList({
    required this.editGameDetailsList,
  });

  factory EditGameDetailsList.fromMap(List<dynamic> map) {
    return EditGameDetailsList(
      editGameDetailsList:
          map.map((x) => EditGameDetailsModel.fromMap(x)).toList(),
    );
  }
}

class EditGameDetailsModel {
  final int shotId;
  final String startDistance;
  final String surface;
  final String holeType;
  final PenaltyType penalty;
  EditGameDetailsModel({
    required this.shotId,
    required this.startDistance,
    required this.surface,
    required this.holeType,
    required this.penalty,
  });

  factory EditGameDetailsModel.fromMap(Map<String, dynamic> map) {
    return EditGameDetailsModel(
      shotId: map['shot_id']?.toInt() ?? 0,
      startDistance: map['start_distance'] ?? '',
      surface: map['surface'] == 'X' ? 'Recovery' : map['surface'] ?? '',
      holeType: map['hole_type'] ?? '9',
      penalty: map['penalty']?.toInt() == 2
          ? PenaltyType.doublePenalty
          : map['penalty']?.toInt() == 1
              ? PenaltyType.penalty
              : PenaltyType.noPenalty,
    );
  }
}
