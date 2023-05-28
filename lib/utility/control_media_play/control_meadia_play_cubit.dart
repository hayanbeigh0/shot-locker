import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'control_meadia_play_state.dart';

class ControlMeadiaPlayCubit extends Cubit<ControlMeadiaPlayState> {
  ControlMeadiaPlayCubit() : super(ControlMeadiaPlayInitial());

  Future<void> stopPlayer() async {
    emit(ControlMeadiaPlayLoading());
    emit(StopMediaPlay());
    return;
  }
}
