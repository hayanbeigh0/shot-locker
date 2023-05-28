import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'surface_selector_state.dart';

class SurfaceSelectorCubit extends Cubit<SurfaceSelectorState> {
  SurfaceSelectorCubit()
      : super(const SurfaceSelectorState(currentSurface: 'Tee'));

  Future<void> emitSelectedSurface({required String currentSurface}) async {
    emit(state.copyWith(currentSurface: currentSurface));
  }
}
