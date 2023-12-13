import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gulim/data/main_api.dart';
import 'package:gulim/domain/repo/main_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MainRepository)
class MainRepositoryImp extends MainRepository {
  final MainApi _api;

  MainRepositoryImp(this._api);

  @override
  Future<String?> getImageData({
    required File file,
  }) async {
    FormData formData = FormData();
    final uploadFile = await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
    );
    formData.files.add(MapEntry('file', uploadFile));
    final response = await _api.getImageData(data: formData);

    return response.data
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(",")
        .join("\n");
  }
}
