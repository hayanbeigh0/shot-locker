import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shot_locker/base/new-round/util/penalty_enum.dart';

part 'penaltytype_state.dart';

class PenaltytypeCubit extends Cubit<PenaltytypeState> {
  PenaltytypeCubit()
      : super(
            const PenaltytypeState(currentPenaltyType: PenaltyType.noPenalty));
  Future<void> emitPenaltyType(
      {required PenaltyType newPenaltyType}) async {
    emit(state.copyWith(currentPenaltyType: newPenaltyType));
  }
}
