import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shot_locker/authentication/model/auth_model.dart';
import 'package:shot_locker/base/range/logic/range_article/range_article_cubit.dart';
import 'package:shot_locker/base/range/model/range_data_model.dart';
import 'package:shot_locker/base/range/repository/range_data_repository.dart';
import 'package:shot_locker/config/token_shared_pref.dart';

part 'range_data_manager_state.dart';

class RangeDataManagerCubit extends Cubit<RangeDataManagerState> {
  final RangeArticleCubit rangeArticleCubit;
  RangeDataManagerCubit({
    required this.rangeArticleCubit,
  }) : super(RangeDataManagerInitial());
  final _rangeDataRepository = RangeDataRepository();
  final List<String> _rangeHeadings = [
    'Driving',
    'Approach Play',
    'Short Game',
    'Putting',
  ];

  final List<RangeDataModel> _rangeDataList = [];

  Future<void> fetchArticleOfsubHeading({
    required BuildContext context,
    required String subHeading,
  }) async {
    final _token = await TokenSharedPref().fetchStoredToken();
    try {
      await rangeArticleCubit.rangeArticleLoading();
      final _articleList = await _rangeDataRepository
          .fetchArticlesFromSubHeading(
            tokenData: _token,
            subHeading: subHeading,
          )
          .then(
            (response) => List<RangeArticleModel>.from(
              response.data.map((x) => RangeArticleModel.fromRawJson(x)),
            ),
          );
      await rangeArticleCubit.rangeArticleFetched(
        articleList: _articleList,
        subHeading: subHeading,
      );
      return;
    } catch (e) {
      await rangeArticleCubit.rangeArticleError(error: 'Something went wrong!');

      return;
    }
  }

  Future<void> fetchRangeData({required BuildContext context}) async {
    final _token = await TokenSharedPref().fetchStoredToken();
    try {
      emit(RangeDataLoading());
      //1st clean the data list
      _rangeDataList.clear();
      for (var heading in _rangeHeadings) {
        final _subHeadingList = await _fetchSubHeadings(
          tokenData: _token,
          heading: heading.contains('Approach Play') ? 'Approaches' : heading,
        );
        _rangeDataList.add(
          RangeDataModel(heading: heading, rangeSubHeading: _subHeadingList),
        );
      }
      emit(
        RangeDataFetched(rangeDataList: _rangeDataList),
      );

      return;
    } catch (e) {
      emit(const RangeDataError(error: 'Something went wrong!'));
      // print('Error while fetch sub heading');
      // print(e);
      return;
    }
  }

  Future<List<RangeSubHeading>> _fetchSubHeadings(
          {required TokenData tokenData, required String heading}) async =>
      await _rangeDataRepository
          .fetchSubHeading(tokenData: tokenData, heading: heading)
          .then(
            (response) => List<RangeSubHeading>.from(
              response.data.map((x) => RangeSubHeading.fromMap(x)),
            ),
          );
}
