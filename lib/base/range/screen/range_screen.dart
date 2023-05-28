import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shot_locker/base/golfer/widgets/user_profile_image.dart';
import 'package:shot_locker/base/logic/go_to_home/go_to_home_cubit.dart';
import 'package:shot_locker/base/range/logic/range_data_manager/range_data_manager_cubit.dart';
import 'package:shot_locker/base/range/screen/range_article_screen.dart';
import 'package:shot_locker/constants/constants.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';
import 'package:shot_locker/utility/loading_indicator.dart';

class RangeScreen extends StatefulWidget {
  const RangeScreen({Key? key}) : super(key: key);

  @override
  State<RangeScreen> createState() => _RangeScreenState();
}

class _RangeScreenState extends State<RangeScreen> {
  final TextStyle _expansionTileStyle = GoogleFonts.raleway(
    fontSize: 17.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    color: Colors.white,
  );

  Future<bool> willPopScope(BuildContext context) async {
    await BlocProvider.of<GoToHomeCubit>(context).goToHome();
    //Return false to not to close the app when the back button will triggered.
    return false;
  }

  @override
  void initState() {
    BlocProvider.of<RangeDataManagerCubit>(context)
        .fetchRangeData(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => willPopScope(context),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () async =>
                  //Go to Golfer page
                  await BlocProvider.of<GoToHomeCubit>(context)
                      .goToIndex(index: 3),
              child: IgnorePointer(
                child: UserProfileImage(
                  circleRadius: 20.r,
                  allowChangeProfile: false,
                ),
              ),
            ),
          ),
          title: Text(
            'Range',
            style: GoogleFonts.rubik(
              fontSize: 20.sp,
              color: Colors.white,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w400,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ShotLockerBackgroundTheme(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  BlocBuilder<RangeDataManagerCubit, RangeDataManagerState>(
                    builder: (context, state) {
                      if (state is RangeDataError) {
                        return Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(state.error),
                          ),
                        );
                      } else if (state is RangeDataFetched) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: state.rangeDataList.length,
                            itemBuilder: ((context, index) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 20.h,
                                  ),
                                  child: ExpansionTileCard(
                                    trailing: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    key:
                                        Key(state.rangeDataList[index].heading),
                                    // leading: CircleAvatar(
                                    //   backgroundColor: Colors.grey,
                                    //   child: Text(
                                    //     state.rangeDataList[index].heading[0],
                                    //     style: _avatarTextStyle,
                                    //   ),
                                    // ),
                                    baseColor: Constants.boxBgColor,
                                    expandedColor: Constants.boxBgColor,
                                    title: Text(
                                      state.rangeDataList[index].heading,
                                      style: _expansionTileStyle,
                                    ),
                                    children: List.generate(
                                      state.rangeDataList[index].rangeSubHeading
                                          .length,
                                      (subHeadingIndex) => ExpansionTileItem(
                                        label: state
                                            .rangeDataList[index]
                                            .rangeSubHeading[subHeadingIndex]
                                            .subHeading,
                                        onPressed: () async {
                                          BlocProvider.of<
                                                      RangeDataManagerCubit>(
                                                  context)
                                              .fetchArticleOfsubHeading(
                                            context: context,
                                            subHeading: state
                                                .rangeDataList[index]
                                                .rangeSubHeading[
                                                    subHeadingIndex]
                                                .subHeading,
                                          );
                                          await Navigator.of(context).pushNamed(
                                            RangeArticlesScreen.routeName,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        );
                      } else {
                        return const Expanded(child: LoadingIndicator());
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExpansionTileItem extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ExpansionTileItem({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        bottom: 5.h,
        right: 10.w,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10.r),
            color: Constants.boxBgColor,
          ),
          child: ListTile(
            title: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
            trailing: IconButton(
              // onPressed: onPressed,
              onPressed: onPressed,
              icon: Icon(
                Icons.open_in_new,
                size: 22.sp,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
