part of 'each_round_data_cubit.dart';

abstract class EachRoundDataState extends Equatable {
  const EachRoundDataState();

  @override
  List<Object> get props => [];
}

class EachRoundDataInitial extends EachRoundDataState {}

class EachRoundDataLoading extends EachRoundDataState {}

class EachRoundDataLoadingFailed extends EachRoundDataState {
  final String error;
  const EachRoundDataLoadingFailed({
    required this.error,
  });
}

class EachRoundDataFetched extends EachRoundDataState {
  final ScoreBoardModel scoreBoard;
  final List<HoleDetail> roundDetails;
  const EachRoundDataFetched({
    required this.scoreBoard,
    required this.roundDetails,
  });
}
