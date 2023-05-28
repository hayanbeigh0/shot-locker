import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shot_locker/base/range/model/range_data_model.dart';

part 'range_article_state.dart';

class RangeArticleCubit extends Cubit<RangeArticleState> {
  RangeArticleCubit() : super(RangeArticleInitial());
  Future<void> rangeArticleLoading() async {
    emit(RangeArticleInitial());
    emit(RangeArticleLoading());
    return;
  }

  Future<void> rangeArticleError({required String error}) async {
    emit(RangeArticleInitial());
    emit(RangeArticleFetchError(error: error));
    return;
  }

  Future<void> rangeArticleFetched({
    required List<RangeArticleModel> articleList,
    required String subHeading,
  }) async {
    emit(RangeArticleLoading());
    emit(RangeArticleFetched(articleList: articleList, subHeading: subHeading));
    return;
  }
}
