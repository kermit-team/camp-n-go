import 'package:campngo/config/constants.dart';
import 'package:campngo/core/token_storage.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final Dio dio;

  TokenInterceptor({required this.tokenStorage, required this.dio});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await tokenStorage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      //if unauthorized
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        final options = err.response!.requestOptions;
        final accessToken = await tokenStorage.getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        try {
          final response = await dio.request(
            options.path,
            options: Options(
              method: options.method,
              headers: options.headers,
            ),
            data: options.data,
            queryParameters: options.queryParameters,
          );
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }
    handler
        .next(err); // Jeśli nie udało się odświeżyć tokena, przekaż błąd dalej
  }

  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await dio.post(
        '${Constants.apiUrl}/accounts/token/refresh',
        data: {'refresh': refreshToken},
      );

      final newAccessToken = response.data['access'];
      // final newRefreshToken = response.data['refresh_token'];

      await tokenStorage.saveTokens(newAccessToken, refreshToken);
      return true;
    } catch (e) {
      await tokenStorage.clearTokens();
      return false;
    }
  }
}
