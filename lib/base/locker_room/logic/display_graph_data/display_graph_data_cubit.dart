import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:shot_locker/base/locker_room/model/graph_data_model.dart';

part 'display_graph_data_state.dart';

class DisplayGraphDataCubit extends Cubit<DisplayGraphDataState> {
  DisplayGraphDataCubit() : super(DisplayGraphDataInitial());

  Future<void> graphDataLoading() async {
    emit(DisplayGraphDataInitial());
    emit(GraphDataLoading());
    return;
  }

  Future<void> graphDataError({required String error}) async {
    emit(DisplayGraphDataInitial());
    emit(GraphDataLoadingError(error: error));
    return;
  }

  Future<void> graphDataFetched(
      {required String shotName, required Response response}) async {
    emit(DisplayGraphDataInitial());
    try {
      switch (shotName) {
        case 'tee-shot':
          final _driverModel = DriverModel.fromJson(response.data);
          return emit(
            DisplayTeeGraphData(
              heading: 'Driver',
              driverModel: _driverModel,
            ),
          );

        case 'approaches':
          final _approachModel = ApproachesModel.fromJson(response.data);
          return emit(
            DisplayApproachGraphData(
              heading: 'Approaches',
              approachesModel: _approachModel,
            ),
          );

        case 'short-game':
          final _shortGameModel = ShortGameModel.fromJson(response.data);
          return emit(
            DisplayShortGameGraphData(
              heading: 'Short Game',
              shortGameModel: _shortGameModel,
            ),
          );
        case 'putting':
          final _puttingModel = PuttingModel.fromJson(response.data);
          return emit(
            DisplayPuttingGraphData(
              heading: 'Putting',
              puttingModel: _puttingModel,
            ),
          );

        default:
          return emit(
            const GraphDataLoadingError(error: 'Unexpected error occured!'),
          );
      }
    } catch (e) {
      emit(
        const GraphDataLoadingError(error: 'Unexpected error occured!'),
      );
      return;
    }
  }
}
