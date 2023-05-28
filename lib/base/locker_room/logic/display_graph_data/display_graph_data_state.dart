part of 'display_graph_data_cubit.dart';

abstract class DisplayGraphDataState extends Equatable {
  const DisplayGraphDataState();

  @override
  List<Object> get props => [];
}

class DisplayGraphDataInitial extends DisplayGraphDataState {}

class GraphDataLoadingError extends DisplayGraphDataState {
  final String error;
  const GraphDataLoadingError({
    required this.error,
  });
}

class GraphDataLoading extends DisplayGraphDataState {}

class DisplayTeeGraphData extends DisplayGraphDataState {
  final String heading;
  final DriverModel driverModel;
  const DisplayTeeGraphData({
    required this.heading,
    required this.driverModel,
  });
}

class DisplayApproachGraphData extends DisplayGraphDataState {
  final String heading;
  final ApproachesModel approachesModel;

  const DisplayApproachGraphData({
    required this.heading,
    required this.approachesModel,
  });
}

class DisplayShortGameGraphData extends DisplayGraphDataState {
  final String heading;
  final ShortGameModel shortGameModel;

  const DisplayShortGameGraphData({
    required this.heading,
    required this.shortGameModel,
  });
}

class DisplayPuttingGraphData extends DisplayGraphDataState {
  final String heading;
  final PuttingModel puttingModel;

  const DisplayPuttingGraphData({
    required this.heading,
    required this.puttingModel,
  });
}
