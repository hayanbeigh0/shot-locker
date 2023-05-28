import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'hole_list_state.dart';

class HoleListCubit extends Cubit<HoleListState> {
  HoleListCubit() : super(const HoleListState(holeNumberList: [1]));
  Future<void> emitHolesNumber({required int holesNumber}) async {
    final List<int> _numberList = [];
    for (var i = 1; i <= holesNumber; i++) {
      _numberList.add(i);
    }
    emit(state.copyWith(newNumberList: _numberList));
  }
}
