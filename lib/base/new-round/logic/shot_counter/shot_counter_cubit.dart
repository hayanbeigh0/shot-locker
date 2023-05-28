import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'shot_counter_state.dart';

class ShotCounterCubit extends Cubit<ShotCounterState> {
  ShotCounterCubit()
      : super(
          const ShotCounterState(
            currentShot: 1,
          ),
        );

  Future<void> emitCurrentShot({required int currentShot}) async {
    emit(
      state.copyWith(
        currentShot: currentShot,
      ),
    );
    return;
  }
}
