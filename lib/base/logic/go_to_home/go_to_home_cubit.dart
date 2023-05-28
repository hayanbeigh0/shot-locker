import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'go_to_home_state.dart';

class GoToHomeCubit extends Cubit<GoToHomeState> {
  GoToHomeCubit() : super(GoToHomeInitial());
  Future<void> goToHome() async {
    emit(GoToHomeInitial());
    emit(GoToHomeTriggered());
    return;
  }

  Future<void> goToIndex({required int index}) async {
    emit(GoToHomeInitial());
    emit(GoToSelectedPage(index: index));
    return;
  }
}
