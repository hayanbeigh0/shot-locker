part of 'range_article_cubit.dart';

abstract class RangeArticleState extends Equatable {
  const RangeArticleState();

  @override
  List<Object> get props => [];
}

class RangeArticleInitial extends RangeArticleState {}

class RangeArticleLoading extends RangeArticleState {}

class RangeArticleFetched extends RangeArticleState {
  final String subHeading;
  final List<RangeArticleModel> articleList;
  const RangeArticleFetched({
    required this.subHeading,
    required this.articleList,
  });
}

class RangeArticleFetchError extends RangeArticleState {
  final String error;
  const RangeArticleFetchError({
    required this.error,
  });
}
