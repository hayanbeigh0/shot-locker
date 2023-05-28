import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shot_locker/authentication/model/auth_model.dart';
import 'package:shot_locker/base/locker_room/model/round_data_fetch_model.dart';
import 'package:shot_locker/base/locker_room/repository/each_round_data_repository.dart';
import 'package:shot_locker/config/token_shared_pref.dart';
part 'each_round_data_state.dart';

class EachRoundDataCubit extends Cubit<EachRoundDataState> {
  EachRoundDataCubit() : super(EachRoundDataInitial());
  final _eachRoundDataRepository = EachRoundDataRepository();

  Future<void> emitDefault() async {
    emit(EachRoundDataLoading());
    emit(EachRoundDataInitial());
    return;
  }

  Future<void> fetchEachRoundData(
      {required BuildContext context, required String gameId}) async {
    final tokenData = await TokenSharedPref().fetchStoredToken();
    emit(EachRoundDataLoading());
    try {
      final scoreDetails = await fetchEachRoundScoreDetails(
        gameId: gameId,
        tokenData: tokenData,
      );
      final scoreResults = await _fetchEachRoundScoreResult(
        gameId: gameId,
        tokenData: tokenData,
      );

      emit(
        EachRoundDataFetched(
          scoreBoard: scoreResults,
          roundDetails: scoreDetails,
        ),
      );
      return;
    } catch (e) {
      emit(const EachRoundDataLoadingFailed(error: 'Something went wrong!'));
    }
  }

  Future<List<HoleDetail>> fetchEachRoundScoreDetails(
          {required String gameId, required TokenData tokenData}) async =>
      await _eachRoundDataRepository
          .fetchEachRoundScoreDetails(
            tokenData: tokenData,
            gameId: gameId,
          )
          .then(
            (response) => List<HoleDetail>.from(
              response.data.map((x) => HoleDetail.fromJson(x)),
            ),
          );

  Future<ScoreBoardModel> _fetchEachRoundScoreResult(
          {required String gameId, required TokenData tokenData}) async =>
      await _eachRoundDataRepository
          .fetchEachRoundScore(
            tokenData: tokenData,
            gameId: gameId,
          )
          .then((response) => ScoreBoardModel.fromJson(response.data));
}
