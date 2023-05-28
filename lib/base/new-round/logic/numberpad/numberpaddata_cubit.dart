import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'numberpaddata_state.dart';

class NumberPadDataCubit extends Cubit<NumberPadDataState> {
  NumberPadDataCubit() : super(const NumberPadDataState(currentText: '0'));
  Future<void> emitNumber({required String currentText}) async {
    emit(state.copyWith(currentText: currentText));
  }
}
