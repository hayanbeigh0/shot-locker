// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shot_locker/base/golfer/screen/golfer_screen.dart';
import 'package:shot_locker/base/locker_room/screen/dash_board_screen.dart';
import 'package:shot_locker/base/logic/go_to_home/go_to_home_cubit.dart';
import 'package:shot_locker/base/logic/round_info.dart';
import 'package:shot_locker/base/new-round/logic/rounds_data_entry_manager/rounds_data_entry_manager_dart_cubit.dart';
import 'package:shot_locker/base/new-round/screens/new_round_screen.dart';
import 'package:shot_locker/base/new-round/screens/round_entry_screens/select_date_screen.dart';
import 'package:shot_locker/base/range/screen/range_screen.dart';
import 'package:shot_locker/base/widgets/fab_bottom_bar.dart';
import '../explore/screen/explore_screen.dart';

class BaseScreen extends StatefulWidget {
  static const routeName = 'base_screen';

  const BaseScreen({Key? key}) : super(key: key);

  @override
  //#LeadP9973
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;
  RoundInfo roundInfo = RoundInfo();
  static const List<Widget> _widgetOptions = <Widget>[
    //LockerRoom(),
    DashBoardScreen(),
    RangeScreen(),
    ExploreScreen(),
    GolferScreen()
  ];

  void _selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildFab(BuildContext context) {
    return SizedBox(
      height: 60.h,
      width: 60.w,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () async {
            await HapticFeedback.lightImpact();
            //reset the entered value on data entry page
            BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                .emitDefaultValues();
            //
            final lastGameStatus =
                await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                    .checkLastGameStatus(context: context);
            final gameId =
                await BlocProvider.of<RoundsDataEntryManagerDartCubit>(context)
                    .getCourseId();
            if (gameId != null) roundInfo.setCourse(gameId);

            if (lastGameStatus == true || lastGameStatus == null) {
              await Navigator.of(context).pushNamed(SelectDateScreen.routeName);
              return;
            } else if (lastGameStatus == false) {
              //!Navigate to Data entry screen
              await Navigator.of(context).pushNamed(
                NewRoundScreen.routeName,
                arguments: roundInfo,
              );
              return;
            } else {
              return;
            }
          },
          tooltip: 'Increment',
          elevation: 2.0,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 35.sp,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BlocListener<GoToHomeCubit, GoToHomeState>(
        listener: (context, state) {
          if (state is GoToHomeTriggered) {
            _selectedTab(0);
          } else if (state is GoToSelectedPage) {
            _selectedTab(state.index);
          }
        },
        child: FABBottomBar(
          currentIndex: _selectedIndex,
          backgroundColor: Colors.black,
          centerItemText: 'New Round',
          color: Colors.grey,
          selectedColor: Colors.white,
          notchedShape: const CircularNotchedRectangle(),
          onTabSelected: _selectedTab,
          items: [
            FABBottomBarItem(iconData: Icons.show_chart, text: 'Locker\nRoom'),
            FABBottomBarItem(
                iconData: Icons.play_lesson_outlined, text: 'Range'),
            FABBottomBarItem(iconData: Icons.explore, text: 'Explore'),
            FABBottomBarItem(iconData: Icons.sports_golf, text: 'Golfer'),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context),
    );
  }
}
