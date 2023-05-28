part of 'round_manager_cubit.dart';

abstract class RoundManagerState extends Equatable {
  const RoundManagerState();

  @override
  List<Object> get props => [];
}

class RoundManagerInitial extends RoundManagerState {}

class RoundDataLoading extends RoundManagerState {}

class RoundDataEmptyState extends RoundManagerState {}
class TokenFail extends RoundManagerState {}

class RoundDataFetched extends RoundManagerState {
  final RoundDataFetchModel roundDataDetails;
  const RoundDataFetched({
    required this.roundDataDetails,
  });
}

class RoundDataLoadFailed extends RoundManagerState {}
