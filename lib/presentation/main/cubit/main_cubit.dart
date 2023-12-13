import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gulim/common/cubit/buildable_cubit.dart';
import 'package:gulim/domain/repo/main_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'main_cubit.freezed.dart';

part 'main_state.dart';

@Injectable()
class MainCubit extends BuildableCubit<MainState, MainBuildable> {
  MainCubit(this._repository, this._log) : super(const MainBuildable());

  final MainRepository _repository;
  final Logger _log;

  Future<File?> getImage(ImageSource source) async {
    File pickedImage;
    var image = await ImagePicker()
        .pickImage(
          source: source,
          imageQuality: 25,
        )
        .onError((error, stackTrace) => null);

    if (image == null) {
      return null;
    }
    pickedImage = File(image.path);
    return pickedImage;
  }

  Future<void> uploadImage({
    required ImageSource source,
  }) async {
    try {
      final file = await getImage(source);
      build((buildable) => buildable.copyWith(scanning: true, result: null));
      if (file == null) {
        return;
      }
      build((buildable) => buildable.copyWith(file: file));
      final result = await _repository.getImageData(file: file) as String;
      build((buildable) => buildable.copyWith(result: result));
    } catch (e) {
      _log.d(e.toString());
      build(
        (buildable) =>
            buildable.copyWith(result: 'Something went wrong, try again!'),
      );
    } finally {
      build((buildable) => buildable.copyWith(scanning: false));
    }
  }
}
