// ignore_for_file: use_build_context_synchronously

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/locker_room/logic/round_manager/round_manager_cubit.dart';
import 'package:shot_locker/base/locker_room/screen/each_round_details.dart';
import 'package:shot_locker/base/logic/round_info.dart';
import 'package:shot_locker/base/new-round/logic/rounds_data_entry_manager/rounds_data_entry_manager_dart_cubit.dart';
import 'package:shot_locker/base/new-round/logic/shot_counter/shot_counter_cubit.dart';
import 'package:shot_locker/base/screen/base_screen.dart';
import 'package:shot_locker/constants/constants.dart';
import 'package:shot_locker/constants/enums.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';
import '../widgets/data_entry/data_entry_widget.dart';

class NewRoundScreen extends StatefulWidget {
  static const routeName = 'new_round_screen';
  final RoundInfo roundInfo;
  const NewRoundScreen({required this.roundInfo});

  @override
  State<NewRoundScreen> createState() => _NewRoundScreenState();
}

class _NewRoundScreenState extends State<NewRoundScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _tabController?.addListener(() {
      setState(() {
        _tabController?.index ?? 0;
      });
    });
    super.initState();
  }

  void _popAfterGameDetailsChange() {
    final roundDataEntryCubit =
        BlocProvider.of<RoundsDataEntryManagerDartCubit>(context);
    final isLastGameCompleted = roundDataEntryCubit.isLastGameCompleted;
    final isEditDetails = roundDataEntryCubit.isEditGameDetails;
    if (isLastGameCompleted && !isEditDetails) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const BaseScreen(),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<bool> willPopScope(BuildContext context) async {
    await HapticFeedback.heavyImpact();
    final actionResponse = await showDialog<GameAction>(
      context: context,
      builder: (_) => SimpleDialog(
        backgroundColor: Constants.boxBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: const BorderSide(color: Colors.white),
        ),
        title: Text(
          'Action required',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        children: [
          const Divider(color: Colors.white),
          SimpleDialogOption(
            onPressed: () async {
              await HapticFeedback.lightImpact();
              //Close the dialog box
              Navigator.of(context).pop(GameAction.finish);
              return;
            },
            child: Text(
              'Finish the current round',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
          const Divider(color: Colors.white),
          SimpleDialogOption(
            onPressed: () async {
              await HapticFeedback.lightImpact();
              //Close the dialog box
              if (await BlocProvider.of<RoundsDataEntryManagerDartCubit>(
                      context)
                  .deleteCurrentGameEntry(context: context)) {
                //Refresh the home page data.
                BlocProvider.of<RoundManagerCubit>(context)
                    .onRefreshFetchData(context: context);
                _popAfterGameDetailsChange();
                if (BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                    .isEditGameDetails) {
                  Navigator.of(context)
                      .pop(GameAction.delete); //Close the game details screen.
                }
              }
            },
            child: Text(
              'Delete the current round',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
    //Refresh the home page data.
    BlocProvider.of<RoundManagerCubit>(context)
        .onRefreshFetchData(context: context);
    //
    //Return false to not to close the app when the back button will triggered.
    if (actionResponse == GameAction.finish) {
      //Save the last data entry //Add/Update shot
      await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
          .addOrUpdateShot(
        context,
        showLastGameSavedSnakbar: true,
      );
      if (await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
          .finishCurrentGameEntry(context: context)) {
        _popAfterGameDetailsChange();

        return true;
      } else {
        return false;
      }
    } else if (actionResponse == GameAction.delete) {
      if (await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
          .deleteCurrentGameEntry(context: context)) {
        _popAfterGameDetailsChange();
        if (BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
            .isEditGameDetails) {
          Navigator.pop(context); //Close the game details screen.
        }
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  final List<Tab> tabs = const [Tab(text: ''), Tab(text: '')];

  final List<String> _title = ['Data Entry', 'Score Card'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          flexibleSpace: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BubbleTabIndicator(
              indicatorHeight: 25.h,
              indicatorColor: Colors.transparent,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            tabs: tabs,
            controller: _tabController,
          ),
          title: BlocBuilder<ShotCounterCubit, ShotCounterState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _tabController?.index == 0 
                      ? 'Shot ${state.currentShot}'
                      : _title[_tabController?.index ?? 0],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _tabController?.index == 0 ? 22.sp : 20.sp,
                  ),
                ),
              );
            },
          ),
        ),
        body: WillPopScope(
          onWillPop: () => willPopScope(context),
          child: TabBarView(
            controller: _tabController,
            children: [
              ShotLockerBackgroundTheme(
                  child: DataEntryWidget(
                roundInfo: widget.roundInfo,
              )),
              const EachRoundDetails(heading: '', isScoreCard: true),
            ],
          ),
        ),
      ),
    );
  }
}
