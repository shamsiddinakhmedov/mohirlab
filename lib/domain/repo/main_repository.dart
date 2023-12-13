import 'dart:io';

abstract class MainRepository {
  Future<String?> getImageData({
    required File file,
  });
}
