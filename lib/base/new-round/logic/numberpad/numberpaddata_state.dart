part of 'numberpaddata_cubit.dart';

class NumberPadDataState extends Equatable {
  final String currentText;
  const NumberPadDataState({
    required this.currentText,
  });
  NumberPadDataState copyWith({String? currentText}) =>
      NumberPadDataState(currentText: currentText ?? this.currentText);
  @override
  List<Object> get props => [currentText];
}
