// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:shot_locker/base/locker_room/logic/each_round_data/each_round_data_cubit.dart';
import 'package:shot_locker/base/logic/round_info.dart';
import 'package:shot_locker/base/new-round/logic/add_update_button/addupdatebutton_cubit.dart';
import 'package:shot_locker/base/new-round/logic/hole_counter/hole_counter_cubit.dart';
import 'package:shot_locker/base/new-round/logic/hole_list/hole_list_cubit.dart';
import 'package:shot_locker/base/new-round/logic/numberpad/numberpaddata_cubit.dart';
import 'package:shot_locker/base/new-round/logic/penalty_handler/penaltytype_cubit.dart';
import 'package:shot_locker/base/new-round/logic/shot_counter/shot_counter_cubit.dart';
import 'package:shot_locker/base/new-round/logic/surface_selector/surface_selector_cubit.dart';
import 'package:shot_locker/base/new-round/model/check_game_details_model.dart';
import 'package:shot_locker/base/new-round/model/course_list_model.dart';
import 'package:shot_locker/base/new-round/model/edit_game_details_model.dart';
import 'package:shot_locker/base/new-round/model/prefilled_data_model.dart';
import 'package:shot_locker/base/new-round/model/shot_details_model.dart';
import 'package:shot_locker/base/new-round/repository/game_data_management_repository.dart';
import 'package:shot_locker/base/new-round/screens/new_round_screen.dart';
import 'package:shot_locker/base/new-round/util/penalty_enum.dart';
import 'package:shot_locker/config/token_shared_pref.dart';
import 'package:shot_locker/utility/loading_spinner_dialogbox.dart';
import 'package:shot_locker/utility/show_snak_bar.dart';
part 'rounds_data_entry_manager_dart_state.dart';

class RoundsDataEntryManagerDartCubit
    extends Cubit<RoundsDataEntryManagerDartState> {
  final HoleCounterCubit holeCounterCubit;
  final HoleListCubit holeListCubit;
  final ShotCounterCubit shotCounterCubit;
  final SurfaceSelectorCubit surfaceSelectorCubit;
  final NumberPadDataCubit numberPadDataCubit;
  final PenaltytypeCubit penaltytypeCubit;
  final AddupdatebuttonCubit addupdatebuttonCubit;
  RoundsDataEntryManagerDartCubit({
    required this.holeCounterCubit,
    required this.holeListCubit,
    required this.shotCounterCubit,
    required this.surfaceSelectorCubit,
    required this.numberPadDataCubit,
    required this.penaltytypeCubit,
    required this.addupdatebuttonCubit,
  }) : super(RoundsDataEntryManagerDartInitial());

  final _gameDataManagementRepository = GameDataManagementRepository();
  //Default value
  String courseName = '';
  String holeType = '9 Holes';
  String addShotButtonName = 'Next';
  DateTime selectedDate = DateTime.now();
  PenaltyType penaltyType = PenaltyType.noPenalty;
  int currentSelectedShot = 1;
  late int _currentShot;
  int currentSelectedHole = 1;
  late int currentHoleShots = 0;
  List<int> shotCountList =
      List<int>.generate(12, (index) => index + 1); //[1,2,3,4...,12]
  List<String> surfaceType = [
    'Tee',
    'Fairway',
    'Rough',
    'Sand',
    'Recovery',
    'Green',
    '',
  ];
  List<CourseListModel> _savedcouseList = [];
  List<CourseWithDistanceListModel> _searchedcouseList = [];
  List<CourseWithDistanceListModel> courseListInDB = [];
  int selectedSurfaceIndex = 0;
  String typedNumber = '0';

  //After game created
  int? _gameId;
  int? _tempShotId;
  GameDetailsModel? shotIdDetails;
  bool isLastGameCompleted = false;
  bool allowLastValuetoUpload = true;
  bool _allowNextShot = true;
  bool _isShotOver = false;
  bool isEditGameDetails = false;

  late StreamSubscription buttonTextStreamSubscription;
  late final StreamController buttonTextController =
      StreamController.broadcast();
  late StreamSubscription numberPadCubitStateSubcription;
  late Stream buttonText = buttonTextController.stream;

  bool isForward = false;

  void _setAllowEdit(int shotCount) {
    _emitAddUpdateButtonStatus(allowEdit: _currentShot != shotCount);
  }

  Future<void> addOrUpdateShot(
    BuildContext context, {
    bool showLastGameSavedSnakbar = false,
    bool dataValidation = false,
    bool isSratch = false,
  }) async {
    if (int.parse(typedNumber) > 0 || dataValidation) {
      if (addShotButtonName.toLowerCase().contains('next')) {
        if (surfaceType[selectedSurfaceIndex].isEmpty) {
          ShowSnackBar.showSnackBar(context, 'Please add some shot value!!!');
        } else {
          await createShotEntry(
            context: context,
            isScratch: isSratch,
          );
        }
        //Trigger the each round data fetch after the user
        //click Add button to create shot entry
        if (shotIdDetails != null) {
          BlocProvider.of<EachRoundDataCubit>(context).fetchEachRoundData(
            context: context,
            gameId: shotIdDetails!.gameId.toString(),
          );
        }
      } else if (addShotButtonName.toLowerCase().contains('update') ||
          addShotButtonName.toLowerCase().contains('forward')) {
        await updateShotEntry(context: context);
        //Trigger the each round data fetch after the user
        //click Add button to create shot entry
        if (shotIdDetails != null) {
          BlocProvider.of<EachRoundDataCubit>(context).fetchEachRoundData(
            context: context,
            gameId: shotIdDetails!.gameId.toString(),
          );
        }
      }

      if (showLastGameSavedSnakbar) {
        ShowSnackBar.showSnackBar(context, 'Last hole saved successfully');
      }
    } else {
      ShowSnackBar.showSnackBar(context, 'Please add shot value!!!');
    }
  }

  Future<bool> fetchGameDetailsByHole({
    required String gameId,
    String holeNumber = '1',
  }) async {
    try {
      final token = await TokenSharedPref().fetchStoredToken();
      final response =
          await _gameDataManagementRepository.checkGameDetailsByHoleStatus(
        tokenData: token,
        gameId: gameId,
        holeNumber: holeNumber,
      );
      final editGameDetailsList =
          EditGameDetailsList.fromMap(response.data).editGameDetailsList;
      currentHoleShots = editGameDetailsList.length;
      print('Total hole shots: ${editGameDetailsList.length}');
      print('Current shot: $_currentShot');
      _currentShot = editGameDetailsList.length + 1;
      if (editGameDetailsList.isNotEmpty) {
        buttonTextController.add('Forward');
        final firstShotDetails = editGameDetailsList[0];
        _gameId = int.parse(gameId);
        currentSelectedShot = 1;
        await _checkShotDetails(queryShotId: firstShotDetails.shotId);
        await setHoleType(holeType: firstShotDetails.holeType);
        await holeCounterCubit.emitCurrentHole(
          selectedHole: shotIdDetails!.hole.toString(),
        );
        await surfaceSelectorCubit.emitSelectedSurface(
          currentSurface: surfaceType[selectedSurfaceIndex],
        );
        await penaltytypeCubit.emitPenaltyType(
          newPenaltyType: shotIdDetails!.penalty,
        );
        await numberPadDataCubit.emitNumber(
          currentText: shotIdDetails!.startDistance,
        );

        //Change the add shot button to Update Shot when the shotIdDetails already have start distance.
        _emitAddUpdateButtonStatus(allowEdit: true);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editGameDetails(
    BuildContext context, {
    required String gameId,
    required String holeNumber,
  }) async {
    try {
      RoundInfo roundInfo = RoundInfo();
      final isLastGameCompleted =
          await checkLastGameStatus(context: context, fetchRoundData: false);
      if (isLastGameCompleted || isLastGameCompleted == null) {
        final token = await TokenSharedPref().fetchStoredToken();
        isEditGameDetails = true;
        _emitAddUpdateButtonStatus(allowEdit: true);
        if (await fetchGameDetailsByHole(
          gameId: gameId,
          holeNumber: holeNumber,
        )) {
          final finalGameDetails =
              await BlocProvider.of<EachRoundDataCubit>(context)
                  .fetchEachRoundScoreDetails(
            tokenData: token,
            gameId: shotIdDetails!.gameId.toString(),
          );

          await _gameDataManagementRepository.unFinishShotEntry(
            tokenData: token,
            shotId: int.parse(finalGameDetails.last.details.last.id),
          );

          return true;
        } else {
          ShowSnackBar.showSnackBar(
            context,
            "Can't edit this game.",
          );
          return false;
        }
      } else {
        roundInfo.setCourse(int.parse(gameId));
        ShowSnackBar.showSnackBar(
          context,
          'First complete the pending game.',
          action: SnackBarAction(
            label: 'Complete',
            textColor: Colors.white,
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pushNamed(
                NewRoundScreen.routeName,
                arguments: roundInfo,
              );
            },
          ),
        );
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void _emitAddUpdateButtonStatus({required bool allowEdit}) {
    // _allowEdit = allowEdit; //Update the global variable

    if (allowEdit) {
      buttonTextStreamSubscription = buttonText.listen((text) {
        addShotButtonName = text;
        addupdatebuttonCubit.emitButtonName(buttonName: text);
      });
      log(shotIdDetails!.startDistance);
      numberPadCubitStateSubcription =
          numberPadDataCubit.stream.listen((state) {
        if (shotIdDetails != null && shotIdDetails!.nextShotId != 0 ||
            currentSelectedShot <= currentHoleShots) {
          try {
            log('hi- $currentSelectedShot $currentHoleShots : $currentSelectedHole');
            if (state.currentText == shotIdDetails!.startDistance) {
              addShotButtonName = 'Forward';
              addupdatebuttonCubit.emitButtonName(buttonName: 'Forward');
            } else {
              addShotButtonName = 'Update';
              addupdatebuttonCubit.emitButtonName(buttonName: 'Update');
            }
          } catch (e) {
            log('hi-- $currentSelectedShot $currentHoleShots : $currentSelectedHole');
            addShotButtonName = 'Next';
            addupdatebuttonCubit.emitButtonName(buttonName: 'Next');
          }
        } else {
          try {
            print(
                'hi --- $currentSelectedShot $currentHoleShots : $currentSelectedHole');
            if (currentSelectedShot <= currentHoleShots) {
              addShotButtonName = 'Forward';
              addupdatebuttonCubit.emitButtonName(buttonName: 'Forward');
            }
          } catch (e) {
            print(
                'hi---- $currentSelectedShot $currentHoleShots : $currentSelectedHole');
            addShotButtonName = 'Next';
            addupdatebuttonCubit.emitButtonName(buttonName: 'Next');
          }
        }
      });
      // if (isForward) {
      //   addShotButtonName = 'Forward';
      //   addupdatebuttonCubit.emitButtonName(buttonName: 'Forward');
      // } else {
      //   addShotButtonName = 'Update';
      //   addupdatebuttonCubit.emitButtonName(buttonName: 'Update');
      // }
    } else {
      addShotButtonName = 'Next';
      addupdatebuttonCubit.emitButtonName(buttonName: 'Next');
    }
  }
  // Future<void> _allowEdit({required int shotCount})

  Future<void> unselectSurface() async {
    selectedSurfaceIndex = surfaceType.length - 1;
    await surfaceSelectorCubit.emitSelectedSurface(
      currentSurface: surfaceType[selectedSurfaceIndex],
    );
    return;
  }

  //Calling this when, user click the new round button.
  Future<void> emitDefaultValues() async {
    await setHoleType(holeType: holeType);
    //Reset hole to 1
    if (currentSelectedHole < (holeType.contains('9') ? 9 : 18)) {
      currentSelectedHole = 1;
      await holeCounterCubit.emitCurrentHole(
        selectedHole: currentSelectedHole.toString(),
      );
    }
    await penaltytypeCubit.emitPenaltyType(
      newPenaltyType: PenaltyType.noPenalty,
    );
    await resetToDefaultValuesonHoleChange();
    return;
  }

  //Reset values on hole change
  Future<void> resetToDefaultValuesonHoleChange() async {
    shotIdDetails = null;
    currentSelectedShot = 1;
    _currentShot = currentSelectedShot;
    //Select Tee when at the first shot.
    selectedSurfaceIndex = 0;
    await surfaceSelectorCubit.emitSelectedSurface(
      currentSurface: surfaceType[selectedSurfaceIndex],
    );
    //
    await shotCounterCubit.emitCurrentShot(currentShot: currentSelectedShot);
    await resetEnteredDetails();
    _emitAddUpdateButtonStatus(allowEdit: true);
    // print(shotIdDetails!.currentSelectedShotId);
    if (shotIdDetails != null) {
      buttonTextController.add('Forward');
    }
    // _emitAddUpdateButtonStatus(allowEdit: false);
    allowLastValuetoUpload = true;
    _allowNextShot = true;
    _isShotOver = false;
    return;
  }

  //Calling this after a shot entry
  Future<void> resetEnteredDetails() async {
    typedNumber = '0';
    penaltyType = PenaltyType.noPenalty;
    await penaltytypeCubit.emitPenaltyType(
      newPenaltyType: penaltyType,
    );
    await numberPadDataCubit.emitNumber(currentText: typedNumber);
    await unselectSurface();

    return;
  }

  Future<void> _checkShotDetails({required int queryShotId}) async {
    final token = await TokenSharedPref().fetchStoredToken();
    log('Query Shotid : $queryShotId');
    shotIdDetails = await _gameDataManagementRepository
        .checkShotStatus(
          tokenData: token,
          queryShot: queryShotId,
          holeNumber: currentSelectedHole,
        )
        .then(
          (response) => GameDetailsModel.fromJson(response.data),
        );
    if (shotIdDetails != null) {
      currentSelectedHole = shotIdDetails!.hole;
      typedNumber = shotIdDetails!.startDistance;
      penaltyType = shotIdDetails!.penalty;
      selectedSurfaceIndex = surfaceType.indexWhere(
        (element) => element.contains(shotIdDetails!.surface),
      );
    }
    return;
  }

  Future<void> savedCoursePrefilledHoleDetails(RoundInfo roundInfo) async {
    try {
      if (courseName.isNotEmpty) {
        final token = await TokenSharedPref().fetchStoredToken();
        final detailsForPrefilled = await _gameDataManagementRepository
            .checkSavedCoursePrefilledDetais(
              tokenData: token,
              roundInfo: roundInfo,
              holeNumber: currentSelectedHole,
            )
            .then(
              (response) => PrefilledDataModel.fromMap(response.data),
            );
        _currentShot = 1;
        currentSelectedShot = _currentShot;
        final prefilledSurfaceIndex = surfaceType.indexWhere(
          (element) => element.contains(detailsForPrefilled.surface),
        );
        selectedSurfaceIndex = prefilledSurfaceIndex;
        await surfaceSelectorCubit.emitSelectedSurface(
          currentSurface: surfaceType[selectedSurfaceIndex],
        );
        penaltyType = detailsForPrefilled.penalty;
        await penaltytypeCubit.emitPenaltyType(
          newPenaltyType: penaltyType,
        );
        typedNumber = detailsForPrefilled.startDistance;
        await numberPadDataCubit.emitNumber(
          currentText: typedNumber,
        );
      }
      return;
    } catch (e) {
      selectedSurfaceIndex = 0;
      await surfaceSelectorCubit.emitSelectedSurface(
        currentSurface: surfaceType[selectedSurfaceIndex],
      );
      return;
    }
  }

  Future<void> setPenalty({
    required PenaltyType selectedPenaltyType,
    required BuildContext context,
  }) async {
    if (penaltyType == selectedPenaltyType) {
      penaltyType = PenaltyType.noPenalty;
    } else {
      penaltyType = selectedPenaltyType;
    }
    await penaltytypeCubit.emitPenaltyType(newPenaltyType: penaltyType);

    return;
  }

  Future<void> setDate({required DateTime selectedDate}) async {
    this.selectedDate = selectedDate;
    return;
  }

  Future<void> setCourseName({required String courseName}) async {
    this.courseName = courseName;
    log('Course Name : $courseName');
    return;
  }

  getCourseName(String course) {
    log(course);
    courseName = course;
    return courseName;
  }

  Future<void> setHoleType({required String holeType}) async {
    this.holeType = holeType;
    await holeListCubit.emitHolesNumber(
        holesNumber: holeType.contains('9') ? 9 : 18);
    return;
  }

  late int nextCount;
  Future<void> _autoNextShot() async {
    try {
      if (currentSelectedShot < shotCountList.length) {
        if (penaltyType == PenaltyType.penalty ||
            penaltyType == PenaltyType.doublePenalty) {
          nextCount = currentSelectedShot += 2;
          log('Penalty type : $penaltyType');
          if (penaltyType == PenaltyType.doublePenalty) {
            log('We are in double penalty');
            await surfaceSelectorCubit.emitSelectedSurface(
              currentSurface: surfaceType[selectedSurfaceIndex],
            );
            await numberPadDataCubit.emitNumber(
              currentText: shotIdDetails!.startDistance,
            );
          }
        } else {
          nextCount = currentSelectedShot += 1;
          log('next count: $nextCount');
        }

        //Update the current shot number with next shot number.
        currentSelectedShot = nextCount;
      }
      //Will use when lastStatus check method run.
      else if (_isShotOver) {
        nextCount = shotCountList.length;
      }
      _setAllowEdit(nextCount);
      await shotCounterCubit.emitCurrentShot(currentShot: nextCount);
    } catch (e) {
      //Exception occure, when _nextCount will not initialize when the counter reached the last shot.
      //Then set the below flag to true.
      _isShotOver = true;
    }

    return;
  }

  getCourseId() {
    return _gameId;
  }

  //Check when a user click the Add button on the middle of the bottom nav bar to check whether the last game is finish or not.
  Future<dynamic> checkLastGameStatus({
    required BuildContext context,
    bool fetchRoundData = true,
  }) async {
    final token = await TokenSharedPref().fetchStoredToken();
    isEditGameDetails = false;
    ShowDialogSpinner.showDialogSpinner(context: context);
    if (fetchRoundData) {
      //Emit 'No Data' on the score card, each round details page.
      await BlocProvider.of<EachRoundDataCubit>(context).emitDefault();
    }
    try {
      final lastGameStatus = await _checkLastGame();
      _gameId = lastGameStatus.gameId;
      //!
      if (!lastGameStatus.isGameFinished) {
        // savedCoursePrefilledHoleDetails();
        _gameId = lastGameStatus.gameId;
        log('Game Id: $_gameId');
        //Store the last shot id, when the checkLastGameStatus() is called (basically after the application restart condition),
        //It is the latest shot with it's shotId and the next shotId is 0.
        //if previousshot() triggered, tempshotId is used to start the chain from last current shot id.
        _tempShotId = lastGameStatus.shotId;
        await _checkShotDetails(queryShotId: lastGameStatus.shotId);
        _currentShot = lastGameStatus.lastShot;
        if (shotIdDetails!.nextShotId == 0) {
          _allowNextShot = false;
        } else {
          _allowNextShot = true;
        }
        currentSelectedShot = lastGameStatus.lastShot;
        //!Fetch score card data of last game id.
        if (shotIdDetails != null && fetchRoundData) {
          BlocProvider.of<EachRoundDataCubit>(context).fetchEachRoundData(
            context: context,
            gameId: shotIdDetails!.gameId.toString(),
          );
        }
        //!
        _isShotOver = currentSelectedShot == shotCountList.length;
        if (_isShotOver) {
          _allowNextShot = false;
          allowLastValuetoUpload = false;
          //!Show the last data

          await surfaceSelectorCubit.emitSelectedSurface(
            currentSurface: surfaceType[selectedSurfaceIndex],
          );
          await penaltytypeCubit.emitPenaltyType(
            newPenaltyType: shotIdDetails!.penalty,
          );
          await numberPadDataCubit.emitNumber(
            currentText: shotIdDetails!.startDistance,
          );
        } else {
          await resetEnteredDetails();
        }
        _currentShot = currentSelectedShot + 1;
        log('Current Shot : $_currentShot');
        //Update the current shot by adding 1 from the last shot.
        //Update shot status.
        await _autoNextShot();
        //Update hole type
        currentSelectedHole = int.parse(lastGameStatus.hole);
        await setHoleType(holeType: lastGameStatus.holeType);
        await holeCounterCubit.emitCurrentHole(
          selectedHole: lastGameStatus.hole,
        );
        //
      }
      //!
      //Close the loading spinner
      Navigator.of(context).pop();
      isLastGameCompleted = lastGameStatus.isGameFinished;
      return isLastGameCompleted;
    } catch (e) {
      Navigator.of(context).pop(); //Close the loading spinner
      if (e is DioError) {
        if (e.response == null) {
          ShowSnackBar.showSnackBar(context, e.message);
        } else {
          if (e.response!.data
              .toString()
              .contains("'NoneType' object has no attribute 'id'")) {
            ShowSnackBar.showSnackBar(
                context, 'Please select a date to proceed.');
            isLastGameCompleted = true;
            return isLastGameCompleted;
          } else if (e.response!.data['message']
              .toString()
              .contains('user has not entered any shot')) {
            try {
              await _gameDataManagementRepository.deleteCurrentGameEntry(
                tokenData: token,
                gameId: e.response!.data['game'],
              );
              isLastGameCompleted = true;
              return isLastGameCompleted;
            } catch (e) {
              ShowSnackBar.showSnackBar(context, 'Unable to add new round');
              return 'error';
            }
          } else {
            ShowSnackBar.showSnackBar(context, e.response!.data.toString());
          }
        }
      } else {
        ShowSnackBar.showSnackBar(context, 'Something went wrong');
      }
      return null;
    }
  }

  Future<void> nextShot({required BuildContext context}) async {
    try {
      ShowDialogSpinner.showDialogSpinner(context: context);
      await fetchGameDetailsByHole(
        gameId: shotIdDetails!.gameId.toString(),
        holeNumber: currentSelectedHole.toString(),
      );
      if (shotIdDetails != null) {
        if (shotIdDetails!.nextShotId != 0) {
          _allowNextShot = true;
          await _checkShotDetails(queryShotId: shotIdDetails!.nextShotId);
          await _autoNextShot();
          //!Show the last data
          await surfaceSelectorCubit.emitSelectedSurface(
            currentSurface: surfaceType[selectedSurfaceIndex],
          );
          await penaltytypeCubit.emitPenaltyType(
            newPenaltyType: shotIdDetails!.penalty,
          );
          await numberPadDataCubit.emitNumber(
            currentText: shotIdDetails!.startDistance,
          );
        } else if (currentSelectedShot == shotCountList.length &&
                shotIdDetails!.nextShotId == 0
            //_currentShot!=1
            ) {
          // await _autoNextShot();
          ShowSnackBar.showSnackBar(context, 'You are on the last shot.');
        } else if (currentSelectedShot != shotCountList.length &&
            shotIdDetails!.nextShotId == 0 &&
            _allowNextShot) {
          await resetEnteredDetails();
          if (penaltyType == PenaltyType.penalty ||
              penaltyType == PenaltyType.doublePenalty) {
            log('pently : $penaltyType');
            nextCount = currentSelectedShot += 2;
          } else {
            log('pently type: $penaltyType');
            log('next count: $nextCount');
            log('Current selected shot: $currentSelectedShot');
            // nextCount = currentSelectedShot += 1; // Needed to comment this line as when we are on the last shot, this line would have been executed and the count would increase but the auto next shot also has the same line as this one so the count would increase again but we only want count to increase once.
          }
          await _autoNextShot();
          _allowNextShot = false;
          _tempShotId = shotIdDetails!.currentSelectedShotId;
        } else {
          //Store the current shot id, when the next shot is 0, if previousshot() triggered,
          //tempshotId is used to start the chain from last current shot id.
          if (_allowNextShot) {
            _tempShotId = shotIdDetails!.previousShotId;
          } else {
            _tempShotId = shotIdDetails!.currentSelectedShotId;
          }
          ShowSnackBar.showSnackBar(context, 'No next data available.');
        }
      } else {
        ShowSnackBar.showSnackBar(context, 'No next data available.');
      }
      //Close the loading spinner
      Navigator.of(context).pop();
      return;
    } catch (e) {
      Navigator.of(context).pop();
      if (e is DioError) {
        ShowSnackBar.showSnackBar(context, e.response!.data);
      } else {
        ShowSnackBar.showSnackBar(context, 'Unable to contiue');
      }
      return;
    }
  }

  // Future<void> nextShot({required BuildContext context}) async {
  //   final token = await TokenSharedPref().fetchStoredToken();
  //   try {
  //     ShowDialogSpinner.showDialogSpinner(context: context);

  //     if (shotIdDetails != null) {
  //       if (shotIdDetails!.nextShotId != 0) {
  //         _allowNextShot = true;
  //         await _checkShotDetails(queryShotId: shotIdDetails!.nextShotId);
  //         if (penaltyType == PenaltyType.penalty ||
  //             penaltyType == PenaltyType.doublePenalty) {
  //           log('next pently : $penaltyType');
  //           nextCount = currentSelectedShot += 2;
  //         } else {
  //           log('next pently type: $penaltyType');
  //           nextCount = currentSelectedShot += 1;
  //         }
  //         log('Next Count : $nextCount');
  //         await _autoNextShot();
  //         //!Show the last data
  //         await surfaceSelectorCubit.emitSelectedSurface(
  //           currentSurface: surfaceType[selectedSurfaceIndex],
  //         );
  //         await penaltytypeCubit.emitPenaltyType(
  //           newPenaltyType: shotIdDetails!.penalty,
  //         );
  //         await numberPadDataCubit.emitNumber(
  //           currentText: shotIdDetails!.startDistance,
  //         );
  //       } else if (currentSelectedShot == shotCountList.length &&
  //               shotIdDetails!.nextShotId == 0
  //           //_currentShot!=1
  //           ) {
  //         // await _autoNextShot();
  //         ShowSnackBar.showSnackBar(context, 'You are on the last shot.');
  //       } else if (currentSelectedShot != shotCountList.length &&
  //           shotIdDetails!.nextShotId == 0 &&
  //           _allowNextShot) {
  //         await resetEnteredDetails();
  //         if (penaltyType == PenaltyType.penalty ||
  //             penaltyType == PenaltyType.doublePenalty) {
  //           log('pently : $penaltyType');
  //           nextCount = currentSelectedShot += 2;
  //         } else {
  //           log('pently type: $penaltyType');
  //           nextCount = currentSelectedShot += 1;
  //         }
  //         log('Next Count : $nextCount');
  //         await _autoNextShot();
  //         _allowNextShot = false;
  //         _tempShotId = shotIdDetails!.currentSelectedShotId;
  //       } else {
  //         //Store the current shot id, when the next shot is 0, if previousshot() triggered,
  //         //tempshotId is used to start the chain from last current shot id.
  //         if (_allowNextShot) {
  //           _tempShotId = shotIdDetails!.previousShotId;
  //         } else {
  //           _tempShotId = shotIdDetails!.currentSelectedShotId;
  //         }
  //         ShowSnackBar.showSnackBar(context, 'No next data available.');
  //       }
  //     } else {
  //       ShowSnackBar.showSnackBar(context, 'No next data available.');
  //     }
  //     //Close the loading spinner
  //     Navigator.of(context).pop();
  //     return;
  //   } catch (e) {
  //     Navigator.of(context).pop();
  //     if (e is DioError) {
  //       ShowSnackBar.showSnackBar(context, e.response!.data);
  //     } else {
  //       ShowSnackBar.showSnackBar(context, 'Unable to contiue');
  //     }
  //     return;
  //   }
  // }

  Future<void> previousShot({required BuildContext context}) async {
    // print('previous');
    // if (currentSelectedShot < currentHoleShots) {
    buttonTextController.add('Forward');
    // }
    try {
      if (shotIdDetails != null) {
        _emitAddUpdateButtonStatus(
          allowEdit: true,
          //When the user click Previous shot, always set the _allowEdit to true.
        );
      }
      if (currentSelectedShot > 1) {
        ShowDialogSpinner.showDialogSpinner(context: context);

        await _checkShotDetails(
          //!If this is true, it means 'shotIdDetails!.currentSelectedShotId', next shotId must be 0.
          queryShotId: (shotIdDetails!.currentSelectedShotId == _tempShotId) &&
                  !_isShotOver
              //So use the latest shotId to start the chain.
              ? shotIdDetails!.currentSelectedShotId
              : shotIdDetails!.previousShotId,
        );
        if (shotIdDetails!.currentSelectedShotId == _tempShotId) {
          _tempShotId = null;
          _allowNextShot = true;
          buttonTextController.add('Forward');
        } else {
          _allowNextShot = false;
        }
        // await resetEnteredDetails();
        //!Show the last data
        await surfaceSelectorCubit.emitSelectedSurface(
          currentSurface: surfaceType[selectedSurfaceIndex],
        );
        await penaltytypeCubit.emitPenaltyType(
          newPenaltyType: shotIdDetails!.penalty,
        );
        await numberPadDataCubit.emitNumber(
          currentText: shotIdDetails!.startDistance,
        );

        if (penaltyType == PenaltyType.penalty ||
            penaltyType == PenaltyType.doublePenalty) {
          final previousCount = currentSelectedShot -= 2;

          await shotCounterCubit.emitCurrentShot(currentShot: previousCount);
        } else {
          final previousCount = currentSelectedShot -= 1;

          await shotCounterCubit.emitCurrentShot(currentShot: previousCount);
        }
        log('Current Shot : $_currentShot');

        //Close the loading spinner
        Navigator.of(context).pop();
        return;
      } else {
        ShowSnackBar.showSnackBar(context, 'No previous data available');
        return;
      }
    } catch (e) {
      //Close the loading spinner
      Navigator.of(context).pop();
      if (e is DioError) {
        ShowSnackBar.showSnackBar(context, e.response!.data);
      } else {
        ShowSnackBar.showSnackBar(context, 'Unable to contiue');
      }
      return;
    }
  }

  Future<void> nextHole(
      {required BuildContext context, required RoundInfo roundInfo}) async {
    if (currentSelectedHole < (holeType.contains('9') ? 9 : 18)) {
      final nextHole = currentSelectedHole += 1;
      await onNewHoleSelected(
        context,
        roundInfo: roundInfo,
        newHole: nextHole.toString(),
      );
    }
  }

  Future<void> scratch(
      {required BuildContext context, required RoundInfo roundInfo}) async {
    if (currentSelectedHole < (holeType.contains('9') ? 9 : 18)) {
      final nextHole = currentSelectedHole += 1;
      await onNewHoleSelected(context,
          roundInfo: roundInfo, newHole: nextHole.toString());
    }
  }

  Future<void> previousHole(
      {required BuildContext context, required RoundInfo roundInfo}) async {
    if (currentSelectedHole > 1) {
      final previousHole = currentSelectedHole -= 1;
      await onNewHoleSelected(context,
          roundInfo: roundInfo, newHole: previousHole.toString());
    }
  }

  Future<void> onNewHoleSelected(BuildContext context,
      {required RoundInfo roundInfo, required String newHole}) async {
    ShowDialogSpinner.showDialogSpinner(context: context);
    await resetToDefaultValuesonHoleChange();
    currentSelectedHole = int.parse(newHole);
    await holeCounterCubit.emitCurrentHole(selectedHole: newHole);
    if (!isEditGameDetails) {
      await savedCoursePrefilledHoleDetails(roundInfo);
    }
    await fetchGameDetailsByHole(
      gameId: _gameId.toString(),
      holeNumber: newHole,
    );
    //close the spinner
    Navigator.of(context).pop();
    return;
  }

  Future<void> onSurfaceSelected({required int index}) async {
    selectedSurfaceIndex = index;
    await surfaceSelectorCubit.emitSelectedSurface(
      currentSurface: surfaceType[index],
    );
    return;
  }

  Future<void> onNumberSelected(
      {required String number, required BuildContext context}) async {
    if (number == 'C') {
      if (typedNumber.length > 1) {
        typedNumber = typedNumber.substring(0, typedNumber.length - 1);
      } else {
        typedNumber = '0';
      }
    } else {
      if (typedNumber == '0') {
        typedNumber = '';
      }
      //Check if the typeNumber length is >2 or not, this is the limit to set 3 digits number maximum.
      //After 2 digits entry, when we press the number again for the third time, before adding it to typeNumber,
      //we check the typeNumber length is (>2or3) or not. Technically we entered the third digit and the reason
      //the below condiiton is not satisfied because we check before adding the new number to typeNumber.
      //So the 3rd digit also added to typeNumber, when we try to add the 4th digit, then the below condition will satisfied adn it return
      //from here.
      else if (typedNumber.length > 2) {
        ShowSnackBar.showSnackBar(
          context,
          'Numbers allowed from 0-999 only.',
          textColor: Colors.black,
          backGroundColor: Colors.white,
        );
        return;
      }
      typedNumber += number;
    }
    await numberPadDataCubit.emitNumber(
      currentText: typedNumber,
    );
    return;
  }

  Future<void> createShotEntry({
    required BuildContext context,
    required bool isScratch,
  }) async {
    ShowDialogSpinner.showDialogSpinner(context: context);
    final token = await TokenSharedPref().fetchStoredToken();
    try {
      if (_gameId != null) {
        if (selectedSurfaceIndex == surfaceType.length - 1) {
          //Checking for, is any of the surface is selected or not.
          Navigator.of(context).pop(); //Close the loading spinner
          ShowSnackBar.showSnackBar(
            context,
            'Please select a surface.',
          );
          // return false;
          return;
        } else if (_isShotOver && !allowLastValuetoUpload) {
          Navigator.of(context).pop(); //Close the loading spinner
          ShowSnackBar.showSnackBar(
            context,
            'Max 12 shots are allowed.',
          );
          // return false;
          return;
        } else {
          //Store the shot_id
          if (isScratch) {
            _emitAddUpdateButtonStatus(
              allowEdit: true,
              //When the user click Previous shot, always set the _allowEdit to true.
            );
          }
          final int responseShotId = await _gameDataManagementRepository
              .createShotEntry(
                tokenData: token,
                gameId: _gameId!,
                currentSelectedHole: currentSelectedHole,
                startDistance: typedNumber,
                surfaceType: surfaceType[selectedSurfaceIndex],
                penaltyType: penaltyType,
                isScratch: isScratch,
              )
              .then(
                (response) => response.data['shot_id'],
              );

          //
          Navigator.of(context).pop(); //Close the loading spinner
          final shotNumberBeforeUpdate = currentSelectedShot;
          if (penaltyType == PenaltyType.penalty ||
              penaltyType == PenaltyType.doublePenalty) {
            _currentShot = currentSelectedShot + 2;
          } else {
            _currentShot = currentSelectedShot + 1;
          }

          //Update the current shot by adding 1 from the last shot.
          await _autoNextShot();
          //Store the shotid to use to fetch data if previousshot() triggered
          _tempShotId = responseShotId;
          await _checkShotDetails(queryShotId: responseShotId);
          if (shotIdDetails!.nextShotId == 0) {
            _allowNextShot = false;
          } else {
            _allowNextShot = true;
          }
          //Update the last shot value
          await _gameDataManagementRepository.updateLastShotValue(
            tokenData: token,
            gameId: shotIdDetails!.gameId,
          );
          //Here the current shot will update by addition of 1, if the shot count is less than the total shot length. i.e here length is 12.
          if (_isShotOver) {
            allowLastValuetoUpload = false;
            _emitAddUpdateButtonStatus(
              allowEdit:
                  true, //Now the totals shots are over and the user can edit every shot.
            );
          } else {
            final selectedSurfaceIndexBeforeReset =
                selectedSurfaceIndex; // hold the value to check if the selected surface index is 5 (Green) or not.
            if (penaltyType != PenaltyType.doublePenalty) {
              await resetEnteredDetails();
            }
            if (selectedSurfaceIndexBeforeReset == 5) {
              await onSurfaceSelected(index: selectedSurfaceIndexBeforeReset);
            }
            allowLastValuetoUpload = true;
          }
          //Update the '_isShotOver' by comparing '_shotNumberBeforeUpdate' and 'shotCountList.length', at the end of the method.
          //Because this '_isShotOver' will use on the next shot entry with the 'allowLastValuetoUpload' to allow for the data entry.

          _isShotOver = shotNumberBeforeUpdate == shotCountList.length;

          // return true;
          return;
        }
      } else {
        Navigator.of(context).pop(); //Close the loading spinner
        ShowSnackBar.showSnackBar(context, 'No game id found!');
        // return false;
        return;
      }
    } catch (e) {
      Navigator.of(context).pop(); //Close the loading spinner
      if (e is DioError) {
        if (e.response == null) {
          ShowSnackBar.showSnackBar(context, e.message);
          // return false;
          return;
        } else if (e.response!.statusCode == 500) {
          ShowSnackBar.showSnackBar(
            context,
            'Server error. Sorry for the Inconvenience.',
            backGroundColor: Colors.red,
          );
          // return false;
          return;
        } else if (e.response!.data['message'] != null) {
          ShowSnackBar.showSnackBar(
            context,
            e.response!.data['message'],
            backGroundColor: Colors.red,
          );
          // return false;
          return;
        } else {
          ShowSnackBar.showSnackBar(
            context,
            'Unable to proceed.',
            backGroundColor: Colors.red,
          );
          // return false;
          return;
        }
      } else {
        ShowSnackBar.showSnackBar(context, 'Something went wrong');
        // return false;
        return;
      }
    }
  }

  Future<void> updateShotEntry({required BuildContext context}) async {
    ShowDialogSpinner.showDialogSpinner(context: context);
    final token = await TokenSharedPref().fetchStoredToken();
    try {
      String newSelectedSurface;
      if (shotIdDetails!.surface == 'T') {
        newSelectedSurface = 'Tee';
      } else if (shotIdDetails!.surface == 'R') {
        newSelectedSurface = 'Rough';
      } else if (shotIdDetails!.surface == 'F') {
        newSelectedSurface = 'Fairway';
      } else if (shotIdDetails!.surface == 'S') {
        newSelectedSurface = 'Sand';
      } else if (shotIdDetails!.surface == 'G') {
        newSelectedSurface = 'Green';
      } else if (shotIdDetails!.surface == 'X') {
        newSelectedSurface = 'Recovery';
      } else {
        newSelectedSurface = '';
      }
      log('Start distance ${shotIdDetails!.startDistance}');
      log('Typed Number : $typedNumber');
      log('surface ${shotIdDetails!.surface}');
      log('selected surface ${surfaceType[selectedSurfaceIndex]}');

      if ((addShotButtonName.toLowerCase() == 'forward' ||
          addShotButtonName.toLowerCase() == 'next')) {
        log('Here!!!');
        // isForward = false;
        nextShot(context: context);

        Navigator.of(context).pop();
      } else {
        //Store the shot_id
        final int responseShotId = await _gameDataManagementRepository
            .updateShotEntry(
              currentShotId: shotIdDetails!.currentSelectedShotId,
              tokenData: token,
              gameId: _gameId!,
              currentSelectedHole: currentSelectedHole,
              startDistance: typedNumber,
              surfaceType: surfaceType[selectedSurfaceIndex],
              penaltyType: penaltyType,
            )
            .then(
              (response) => response.data['shot_id'],
            );
        await _checkShotDetails(queryShotId: responseShotId);
        // await _autoNextShot();

        //Update the last shot value
        // addShotButtonName = 'Forward';
        isForward = true;
        _emitAddUpdateButtonStatus(allowEdit: true);
        await _gameDataManagementRepository.updateLastShotValue(
          tokenData: token,
          gameId: shotIdDetails!.gameId,
        );
        addShotButtonName = 'Forward';
        buttonTextController.add(addShotButtonName);
        // addShotButtonName = buttonTextController.toString();
        // _emitAddUpdateButtonStatus(allowEdit: true);
        Navigator.of(context).pop(); //Close the loading spinner
        ShowSnackBar.showSnackBar(
          context,
          'Shot $currentSelectedShot updated successfully.',
        );
        return;
      }
      // if (shotIdDetails!.startDistance == typedNumber
      //     // && shotIdDetails!.surface == newSelectedSurface
      //     ) {
      //   log('Here!!!');
      //   // isForward = false;
      //   nextShot(context: context);

      //   Navigator.of(context).pop();
      // } else {
      //   //Store the shot_id
      //   final int responseShotId = await _gameDataManagementRepository
      //       .updateShotEntry(
      //         currentShotId: shotIdDetails!.currentSelectedShotId,
      //         tokenData: token,
      //         gameId: _gameId!,
      //         currentSelectedHole: currentSelectedHole,
      //         startDistance: typedNumber,
      //         surfaceType: surfaceType[selectedSurfaceIndex],
      //         penaltyType: penaltyType,
      //       )
      //       .then(
      //         (response) => response.data['shot_id'],
      //       );
      //   await _checkShotDetails(queryShotId: responseShotId);
      //   // await _autoNextShot();

      //   //Update the last shot value
      //   // addShotButtonName = 'Forward';
      //   isForward = true;
      //   _emitAddUpdateButtonStatus(allowEdit: true);
      //   await _gameDataManagementRepository.updateLastShotValue(
      //     tokenData: token,
      //     gameId: shotIdDetails!.gameId,
      //   );
      //   addShotButtonName = 'Forward';
      //   Navigator.of(context).pop(); //Close the loading spinner
      //   ShowSnackBar.showSnackBar(
      //     context,
      //     'Shot $currentSelectedShot updated successfully.',
      //   );
      //   return;
      // }
    } catch (e) {
      Navigator.of(context).pop(); //Close the loading spinner
      if (e is DioError) {
        if (e.response == null) {
          ShowSnackBar.showSnackBar(context, e.message);
          // return false;
          return;
        } else if (e.response!.statusCode == 500) {
          ShowSnackBar.showSnackBar(
            context,
            'Server error. Sorry for the Inconvenience.',
            backGroundColor: Colors.red,
          );
          // return false;
          return;
        } else if (e.response!.data['message'] != null) {
          ShowSnackBar.showSnackBar(
            context,
            e.response!.data['message'],
            backGroundColor: Colors.red,
          );
          // return false;
          return;
        } else {
          ShowSnackBar.showSnackBar(
            context,
            'Unable to proceed.',
            backGroundColor: Colors.red,
          );
          // return false;
          return;
        }
      } else {
        ShowSnackBar.showSnackBar(context, 'Something went wrong');
        // return false;
        return;
      }
    }
  }

  Future<CheckGameDetailsModel> _checkLastGame() async =>
      await _gameDataManagementRepository
          .checkLastGameStatus(
              tokenData: await TokenSharedPref().fetchStoredToken())
          .then(
            (response) => CheckGameDetailsModel.fromJson(response.data),
          );

//Game Create
  Future<bool> createNewGameEntry({required BuildContext context}) async {
    log('Course name : $courseName');
    ShowDialogSpinner.showDialogSpinner(context: context);
    final token = await TokenSharedPref().fetchStoredToken();
    try {
      final createGameResponse =
          await _gameDataManagementRepository.createNewGame(
        tokenData: token,
        date: selectedDate,
        golfCourseName: courseName,
        holeType: holeType.contains('9') ? 9 : 18,
      );
      Navigator.of(context).pop(); //Close the loading spinner
      _gameId = createGameResponse.data['id'];
      await holeListCubit.emitHolesNumber(
          holesNumber: holeType.contains('9') ? 9 : 18);
      return true;
    } catch (e) {
      Navigator.of(context).pop(); //Close the loading spinner
      if (e is DioError) {
        if (e.response == null) {
          ShowSnackBar.showSnackBar(context, e.message);
        } else {
          ShowSnackBar.showSnackBar(context, e.response!.data.toString());
        }
      } else {
        ShowSnackBar.showSnackBar(context, 'Something went wrong');
      }
      return false;
    }
  }

//Game Delete
  Future<bool> deleteCurrentGameEntry({required BuildContext context}) async {
    //print('*******Deleting GAME********');
    ShowDialogSpinner.showDialogSpinner(context: context);
    final token = await TokenSharedPref().fetchStoredToken();
    try {
      if (_gameId != null) {
        // final _deleteGameResponse =
        await _gameDataManagementRepository.deleteCurrentGameEntry(
          tokenData: token,
          gameId: _gameId!,
        );
        Navigator.of(context).pop(); //Close the loading spinner
        ShowSnackBar.showSnackBar(context, 'Game deleted successfully');
        return true;
      } else {
        Navigator.of(context).pop(); //Close the loading spinner
        ShowSnackBar.showSnackBar(context, 'No game id found!');
        return false;
      }
    } catch (e) {
      Navigator.of(context).pop(); //Close the loading spinner
      if (e is DioError) {
        if (e.response == null) {
          ShowSnackBar.showSnackBar(context, e.message);
        } else {
          ShowSnackBar.showSnackBar(context, e.response!.data.toString());
        }
      } else {
        ShowSnackBar.showSnackBar(context, 'Something went wrong');
      }
      return false;
    }
  }

//Game Finish
  Future<bool> finishCurrentGameEntry({required BuildContext context}) async {
    ShowDialogSpinner.showDialogSpinner(context: context);
    final token = await TokenSharedPref().fetchStoredToken();
    try {
      if (shotIdDetails?.currentSelectedShotId != null) {
        final finalGameDetails =
            await BlocProvider.of<EachRoundDataCubit>(context)
                .fetchEachRoundScoreDetails(
          tokenData: token,
          gameId: shotIdDetails!.gameId.toString(),
        );
        await _gameDataManagementRepository.finishShotEntry(
          tokenData: token,
          shotId: int.parse(finalGameDetails.last.details.last.id),
        );
        Navigator.of(context).pop(); //Close the loading spinner
        ShowSnackBar.showSnackBar(
          context,
          'Game finished successfully.',
        );
        await resetToDefaultValuesonHoleChange();
        return true;
      } else {
        Navigator.of(context).pop(); //Close the loading spinner
        ShowSnackBar.showSnackBar(
          context,
          'Unable to finish empty game.',
          backGroundColor: Colors.red,
        );
        return false;
      }
    } catch (e) {
      Navigator.of(context).pop(); //Close the loading spinner
      if (e is DioError) {
        if (e.response!.statusCode == 500) {
          ShowSnackBar.showSnackBar(
            context,
            'Server error. Sorry for the Inconvenience.',
            backGroundColor: Colors.red,
          );
          return false;
        }

        ShowSnackBar.showSnackBar(context, e.response!.data.toString());
      } else {
        ShowSnackBar.showSnackBar(context, 'Something went wrong');
      }
      return false;
    }
  }

//Select Course page methods
  Future<void> fetchCourseList({required BuildContext context}) async {
    final token = await TokenSharedPref().fetchStoredToken();
    // print(token.token);
    ShowDialogSpinner.showDialogSpinner(context: context);
    try {
      //Fetch course list from database
      courseListInDB = await _gameDataManagementRepository
          .courseListInDBRepository(tokenData: token);

      //1. If empty list then TEXT('no course near you')
      _searchedcouseList = await _gameDataManagementRepository
          .searchCourseListRepository(
        tokenData: token,
        locationData: await _fetchLocation(),
      )
          .then(
        (response) {
          log('Searched List from Location : $response');
          return List<CourseWithDistanceListModel>.from(
            (response.data).map(
              (x) => CourseWithDistanceListModel.fromMap(x),
            ),
          );
        },
      );

      //remove the course from the courseListInDB list, that match/already present in the locationFetchedCourse
      for (var locationfetchedCourse in _searchedcouseList) {
        courseListInDB.removeWhere(
          (element) => element.courseName == locationfetchedCourse.courseName,
        );
      }
      if (_savedcouseList.isEmpty) {
        _searchedcouseList.addAll(courseListInDB);
      }
      //Add the courses those presents in the DB and not match with the location fetched course.
      _searchedcouseList.addAll(courseListInDB);
      // Close the spinner dialog
      Navigator.of(context).pop();
    } catch (e) {
      //Close the spinner dialog
      Navigator.of(context).pop();
      _savedcouseList = [];
      _searchedcouseList = [];
    }
  }

  Future<List<List<String>>> getSavedCourseSuggestions() async {
    final token = await TokenSharedPref().fetchStoredToken();
    _savedcouseList = await _gameDataManagementRepository
        .savedCourseListRepository(tokenData: token)
        .then(
          (response) => List<CourseListModel>.from(
            (response.data).map((x) => CourseListModel.fromMap(x)),
          ),
        );
    final List<String> tempsavedcouseList = [];
    final List<String> tempidList = [];
    for (var courseName in _savedcouseList) {
      tempsavedcouseList.add(courseName.courseName);
      tempidList.add(courseName.id);
      // print(courseName.id);
    }
    final tempList = [tempsavedcouseList, tempidList];
    return tempList;
  }

  Future<List<CourseWithDistanceListModel>> getSearchedCourseSuggestions(
      String query) async {
    if (_searchedcouseList.isEmpty) {
      return courseListInDB
        ..where((element) {
          final descriptionLower = element.courseName.toLowerCase();
          final queryLower = query.toLowerCase();
          return descriptionLower.contains(queryLower);
        }).toList();
    } else {
      return _searchedcouseList.where((element) {
        final descriptionLower = element.courseName.toLowerCase();
        final queryLower = query.toLowerCase();
        return descriptionLower.contains(queryLower);
      }).toList();
    }
  }

  Future<LocationData> _fetchLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {}
    }
    log('Service Enabled: $serviceEnabled');
    log('Permission: $permissionGranted');
    return await location.getLocation();
  }

  @override
  Future<void> close() {
    // TODO: implement close
    buttonTextStreamSubscription.cancel();
    buttonTextController.close();
    return super.close();
  }
}
