import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class MainApi {
  final Dio _dio;

  MainApi(this._dio);

  Future<Response> getImageData({required FormData data}) {
    return _dio.post('predict', data: data);
  }
}
