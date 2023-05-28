part of 'range_data_manager_cubit.dart';

abstract class RangeDataManagerState extends Equatable {
  const RangeDataManagerState();

  @override
  List<Object> get props => [];
}

class RangeDataManagerInitial extends RangeDataManagerState {}

class RangeDataLoading extends RangeDataManagerState {}

class RangeDataFetched extends RangeDataManagerState {
  final List<RangeDataModel> rangeDataList;
  const RangeDataFetched({
    required this.rangeDataList,
  });
}

class RangeDataError extends RangeDataManagerState {
  final String error;
  const RangeDataError({
    required this.error,
  });
}
