part of 'surface_selector_cubit.dart';

class SurfaceSelectorState extends Equatable {
  final String currentSurface;
  const SurfaceSelectorState({
    required this.currentSurface,
  });
  SurfaceSelectorState copyWith({String? currentSurface}) =>
      SurfaceSelectorState(
          currentSurface: currentSurface ?? this.currentSurface);
  @override
  List<Object> get props => [currentSurface];
}
