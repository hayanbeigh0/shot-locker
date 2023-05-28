// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shot_locker/base/locker_room/logic/display_graph_data/display_graph_data_cubit.dart';
import 'package:shot_locker/base/locker_room/model/round_data_fetch_model.dart';
import 'package:shot_locker/base/locker_room/model/round_data_model.dart';
import 'package:shot_locker/base/locker_room/repository/round_data_repository.dart';
import 'package:shot_locker/base/new-round/logic/rounds_data_entry_manager/rounds_data_entry_manager_dart_cubit.dart';
import 'package:shot_locker/base/new-round/screens/new_round_screen.dart';
import 'package:shot_locker/base/new-round/screens/round_entry_screens/select_date_screen.dart';
import 'package:shot_locker/config/token_shared_pref.dart';
import 'package:shot_locker/utility/show_snak_bar.dart';

part 'round_manager_state.dart';

class RoundManagerCubit extends Cubit<RoundManagerState> {
  final DisplayGraphDataCubit displayGraphDataCubit;
  RoundManagerCubit({
    required this.displayGraphDataCubit,
  }) : super(RoundManagerInitial());

  final _roundDataRepository = RoundDataRepository();

//Default value
  String selectedRoundHeading = 'Last Three Rounds';

  final List<String> roundHeading = [
    'Last Round',
    'Last Three Rounds',
    'Last Five Rounds',
    'Last Ten Rounds',
    'Select Round(s)',
  ];

  String _roundName = '';
  int _roundHeadingIndex = 0;

  List<RoundData> roundPlayed = [RoundData(roundName: 'Select Round(s)')];

  Future<String> _roundNameFormatter(String name) async {
    switch (name) {
      case 'Last Round':
        return 'last';

      case 'Last Three Rounds':
        return 'three';

      case 'Last Five Rounds':
        return 'five';

      case 'Last Ten Rounds':
        return 'ten';

      default:
        return _roundName;
    }
  }

  Future<void> fetchShotDetails(
      {required BuildContext context, required String shotName}) async {
    final token = await TokenSharedPref().fetchStoredToken();
    await displayGraphDataCubit.graphDataLoading();
    try {
      final shotDetailsResponse = await _roundDataRepository.fetchShotDetails(
        tokenData: token,
        roundName: _roundName,
        shotName: shotName,
      );
      //Send data to plot graph with table
      await displayGraphDataCubit.graphDataFetched(
        shotName: shotName,
        response: shotDetailsResponse,
      );
      return;
    } catch (e) {
      await displayGraphDataCubit.graphDataError(
          error: 'Something went wrong!');
      // ShowSnackBar.showSnackBar(context, 'Something went wrong');
      return;
    }
  }

  Future<void> setRound(
      {required int index, required BuildContext context}) async {
    _roundHeadingIndex = index;
    selectedRoundHeading = roundHeading[_roundHeadingIndex];
    _roundName = await _roundNameFormatter(selectedRoundHeading);
    //If the selected round heading is Select Round(s) don't excecute the IF statement
    if (roundHeading.length - 1 != _roundHeadingIndex &&
        _roundName.isNotEmpty) {
      await _fetchRoundData(context: context);
    }
    return;
  }

  Future<void> setRoundAsChecked({required int index}) async {
    if (index == 0) {
      for (var element in roundPlayed) {
        element.isChecked = true;
      }
    } else {
      roundPlayed.elementAt((index)).isChecked = true;
    }
    return;
  }

  Future<void> setRoundAsUnChecked({required int index}) async {
    if (index == 0) {
      for (var element in roundPlayed) {
        element.isChecked = false;
      }
    } else {
      roundPlayed.elementAt((index)).isChecked = false;
    }
    return;
  }

  Future<void> fetchSelectedRoundData({required BuildContext context}) async {
    //Select those round, whose isChecked is true.
    final selectedRound =
        roundPlayed.where((element) => element.isChecked).toList();
    if (selectedRound.isNotEmpty) {
      _roundName = '';
      for (var item in selectedRound) {
        _roundName += '${item.id} ';
      }
      //Remove extra space
      _roundName = _roundName.trim();

      await _fetchRoundData(context: context);
    } else {
      ShowSnackBar.showSnackBar(
        context,
        'Please select at-least one round to retrieve data.',
      );
    }
    return;
  }

  Future<void> onRefreshFetchData({required BuildContext context}) async {
    //!
    if (_roundName.split('').isNotEmpty) {
      //Checking, if the _roundName contains numeric numbers or not.
      //If it is find the numeric number, it means the _roundName contains the
      //Selected round ids. At that that don't assign the selectedRoundHeading with
      //roundHeading[_roundHeadingIndex], because it is always assign 'Select Round(s)' to it.
      //It is creating problem in the _roundNameFormatter() switch-case block.
      if (int.tryParse(_roundName.split('').first) == null) {
        //!Only run when the _roundName doesn't contains numeric number.
        selectedRoundHeading = roundHeading[_roundHeadingIndex];
      }
      _roundName = await _roundNameFormatter(selectedRoundHeading);
    } else {
      //This will run only for once, when the application load the home data
      //for the first time of opening.
      selectedRoundHeading = roundHeading[_roundHeadingIndex];
      _roundName = await _roundNameFormatter(selectedRoundHeading);
    }
    await _fetchRoundData(context: context);
    return;
  }

  Future<void> _fetchRoundData({required BuildContext context}) async {
    final token = await TokenSharedPref().fetchStoredToken();
    // print(_token.token);
    emit(RoundDataLoading());
    try {
      //Reset the list
      roundPlayed = [RoundData(roundName: 'Select Round(s)')];
      //1st fetch user finished game to fetch content for checklist
      final userFinishedGameList =
          await _fetchUserFinishedGame(context: context);
      //Add the list to exsiting round data list
      roundPlayed.addAll(userFinishedGameList);
      final response = await _roundDataRepository.fetchRoundDataForHome(
          tokenData: token, roundName: _roundName);
      final roundDataDetails = await _roundDataRepository
          .fetchRoundDataForHome(
            tokenData: token,
            roundName: _roundName,
          )
          .then((response) => RoundDataFetchModel.fromJson(response.data));
      if (response.statusCode == 401) {
        if (response.data['code'] == 'token_not_valid') {
          emit(TokenFail());
        }
      } else {
        log('Response : ${response.statusCode}');
        emit(RoundDataFetched(roundDataDetails: roundDataDetails));
      }

      return;
    } catch (e) {
      if (e is DioError) {
        if (e.response == null) {
          ShowSnackBar.showSnackBar(context, e.message);
        } else {
          if (e.response!.data.toString().contains('Round is Empty')) {
            emit(RoundDataEmptyState());
            return;
          }
          //When a user play the game for the first time, and close the application after enter a shot,
          //without finish or delete the game.
          else if (e.response!.data.toString().contains('Round is empty')) {
            ShowSnackBar.showSnackBar(
                context, 'Please complete your last game.',
                second: 4,
                action: SnackBarAction(
                  label: 'Continue >',
                  textColor: Colors.white,
                  onPressed: () async {
                    await HapticFeedback.lightImpact();
                    final lastGameStatus =
                        await BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                                context)
                            .checkLastGameStatus(context: context);
                    if (lastGameStatus == true || lastGameStatus == null) {
                      await Navigator.of(context)
                          .pushNamed(SelectDateScreen.routeName);
                      return;
                    } else if (lastGameStatus == false) {
                      //!Navigate to Data entry screen
                      await Navigator.of(context)
                          .pushNamed(NewRoundScreen.routeName);
                      return;
                    } else {
                      return;
                    }
                  },
                ));

            emit(RoundDataEmptyState());
            return;
          } else {
            ShowSnackBar.showSnackBar(context, e.response!.data.toString());
          }
        }
      } else {
        ShowSnackBar.showSnackBar(context, 'Something went wrong');
      }
      // print(_roundName);
      // print("error");
      // print(e);
      emit(RoundDataLoadFailed());
      return;
    }
  }

  Future<List<RoundData>> _fetchUserFinishedGame(
      {required BuildContext context}) async {
    final token = await TokenSharedPref().fetchStoredToken();
    try {
      return await _roundDataRepository
          .fetchUserFinishedGameList(tokenData: token)
          .then(
            (response) => List<RoundData>.from(
              response.data.map((x) => RoundData.fromMap(x)),
            ),
          );
    } catch (e) {
      if (e is DioError) {
        if (e.response == null) {
          ShowSnackBar.showSnackBar(context, e.message);
        } else {
          if (e.response!.statusCode == 401) {
            emit(TokenFail());
          }
        }
      } else {
        ShowSnackBar.showSnackBar(context, 'Something went wrong');
      }
      return [];
    }
  }
}
