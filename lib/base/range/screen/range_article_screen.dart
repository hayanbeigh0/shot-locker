import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shot_locker/base/range/logic/range_article/range_article_cubit.dart';
import 'package:shot_locker/base/range/widgets/show_media_content.dart';
import 'package:shot_locker/constants/constants.dart';
import 'package:shot_locker/utility/back_ground_theme.dart';
import 'package:shot_locker/utility/custom_appbar.dart';
import 'package:shot_locker/utility/loading_indicator.dart';

class RangeArticlesScreen extends StatelessWidget {
  static const routeName = 'range_contents_screen';

  const RangeArticlesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: ShotLockerBackgroundTheme(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: BlocBuilder<RangeArticleCubit, RangeArticleState>(
              builder: (context, state) {
                if (state is RangeArticleFetchError) {
                  return Text(state.error);
                } else if (state is RangeArticleFetched) {
                  return Column(
                    children: [
                      SizedBox(height: 5.h),
                      CustomAppBar(
                        showProfileImage: false,
                        centreWidget: Text(
                          state.subHeading,
                          style: GoogleFonts.rubik(
                            fontSize: 18.sp,
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      state.articleList.isEmpty
                          ? Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  'No article found!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: state.articleList.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Constants.boxBgColor,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 12.h,
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Constants.boxBgColor,
                                            ),
                                            child: Text(
                                              state.articleList[index].title,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.1,
                                              ),
                                            ),
                                          ),
                                          Wrap(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 10.h,
                                                ),
                                                child: ShowMediaContent(
                                                  mediaUrl: state
                                                      .articleList[index]
                                                      .fileLink,
                                                ),
                                              ),
                                              Text(
                                                state.articleList[index]
                                                    .description,
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  );
                } else {
                  return const LoadingIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
