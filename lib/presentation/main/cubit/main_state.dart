part of 'main_cubit.dart';

abstract class MainState {}

@freezed
class MainBuildable extends MainState with _$MainBuildable {
  const factory MainBuildable({
    @Default(false) bool scanning,
    File? file,
    String? result,
  }) = _MainBuildable;
}

@freezed
class MainListenable extends MainState with _$MainListenable {
  const factory MainListenable() = _MainListenable;
}
