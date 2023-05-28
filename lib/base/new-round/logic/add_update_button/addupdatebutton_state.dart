part of 'addupdatebutton_cubit.dart';

 class AddupdatebuttonState extends Equatable {
  final String buttonName;
  const AddupdatebuttonState({
    required this.buttonName,
  });
  AddupdatebuttonState copyWith({String? buttonName}) =>
      AddupdatebuttonState(buttonName: buttonName ?? this.buttonName);
  @override
  List<Object> get props => [buttonName];
}

