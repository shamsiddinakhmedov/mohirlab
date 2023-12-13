import 'package:cookie_jar/cookie_jar.dart' show PersistCookieJar, FileStorage;
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:gulim/domain/model/storage.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class NetworkModule {
  @Named("BaseUrl")
  String get baseUrl => 'http://178.128.233.170:5000/';

  @preResolve
  Future<PersistCookieJar> get jar async {
    final appDocPath = await getApplicationDocumentsDirectory();
    return PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("${appDocPath.path}/.cookies/"),
    );
  }

  Dio dio(
    @Named('BaseUrl') String baseUrl,
    PersistCookieJar jar,
    Storage storage,
  ) {
    final dio = Dio();

    dio.options.baseUrl = baseUrl;

    dio.interceptors.add(CookieManager(jar));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (
          RequestOptions options,
          RequestInterceptorHandler handler,
        ) {
          handler.next(options);
        },
      ),
    );

    final logger = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: true,
      maxWidth: 90,
    );

    dio.interceptors.add(logger);

    return dio;
  }
}
