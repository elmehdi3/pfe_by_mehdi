import 'package:dio/dio.dart';
import 'token_service.dart';

class BaseApiService {
  late Dio dio;
  static const String baseUrl = 'http://localhost:8080/api/v1';

  BaseApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Handle token refresh or logout here
          }
          return handler.next(e);
        },
      ),
    );
  }
}
