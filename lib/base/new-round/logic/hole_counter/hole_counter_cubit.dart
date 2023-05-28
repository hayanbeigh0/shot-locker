import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'hole_counter_state.dart';

class HoleCounterCubit extends Cubit<HoleCounterState> {
  HoleCounterCubit() : super(const HoleCounterState(currentHole: '1'));
  Future<void> emitCurrentHole({required String selectedHole}) async {
    emit(state.copyWith(currentHole: selectedHole));
  }
}
