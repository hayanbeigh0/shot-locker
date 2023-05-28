import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'addupdatebutton_state.dart';

class AddupdatebuttonCubit extends Cubit<AddupdatebuttonState> {
  AddupdatebuttonCubit() : super(const AddupdatebuttonState(buttonName: 'Next'));
  Future<void> emitButtonName({required String buttonName}) async {
    emit(state.copyWith(buttonName: buttonName));
  }
}
