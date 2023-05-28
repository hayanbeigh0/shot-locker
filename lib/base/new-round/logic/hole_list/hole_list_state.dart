part of 'hole_list_cubit.dart';

 class HoleListState extends Equatable {
  final List<int> holeNumberList;
  const HoleListState({
    required this.holeNumberList,
  });
  HoleListState copyWith({List<int>? newNumberList}) =>
      HoleListState(holeNumberList: newNumberList ?? holeNumberList);
  @override
  List<Object> get props => [holeNumberList];
}
