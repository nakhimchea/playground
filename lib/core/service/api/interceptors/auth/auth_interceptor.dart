import 'package:dio/dio.dart' as dio;
import 'package:playground/core/extensions/extensions.dart';
import 'package:playground/core/service/api/endpoint.dart';
import 'package:playground/core/utils/exception_handler.dart';

import '../retry/http_status_codes.dart';

class AuthenticationInterceptor extends dio.Interceptor {
  AuthenticationInterceptor({
    required this.getAccessToken,
    required this.onRefreshToken,
    required this.onFetch,
  });

  final String? Function() getAccessToken;
  final Future<void> Function() onRefreshToken;
  final Future<dio.Response<dynamic>> Function(dynamic) onFetch;

  // String key to denote in request headers
  static const _attemptKey = 'auth_attempted';

  // If 401, try refresh token, then proceed with request again
  static const _maxUnauthAttempts = 2;

  // Routes that does not require auth token
  final _noAuthRequireRoutes = [
    Endpoints.analyzeChatFirebase,
    // Endpoints.login,
    // Endpoints.refreshToken,
  ];

  // Routes that does not need to call refresh-token again if got 401
  static final nonRetryDisabledPaths = [
    // Endpoints.refreshToken,
  ];

  static bool isPathRetriable(Uri uri) => !nonRetryDisabledPaths.any((path) => uri.path.endsWith(path));

  bool _canAttemptRetry(Map<String, dynamic> headers) =>
      headers[_attemptKey] == null || headers[_attemptKey] < _maxUnauthAttempts;

  bool _isTokenNotRequired(dio.RequestOptions options) {
    return _noAuthRequireRoutes.contains(options.uri.path) ||
        (options.headers['requiresToken'] != null && !options.headers['requiresToken']);
  }

  @override
  void onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) async {
    if (_isTokenNotRequired(options)) return super.onRequest(options, handler);

    final token = getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      // options.headers['x-forwarded-authorization'] = 'Bearer $token';
    }

    final isTokenValid = token != null && token != 'Bearer null' && true; //JwtDecoderManager.isTokenValid(token);

    if (!isTokenValid && _canAttemptRetry(options.headers)) {
      try {
        // Call refresh token, then override auth value in headers
        await onRefreshToken();

        // Increment retry count
        options.headers[_attemptKey] ??= 0;
        options.headers[_attemptKey] += 1;

        final ac = getAccessToken();
        if (ac != null) {
          options.headers['Authorization'] = 'Bearer $ac';
          // options.headers['x-forwarded-authorization'] = 'Bearer $ac';
          return super.onRequest(options, handler);
        }
      } catch (exception, trace) {
        // Only throws non Dio.Error exceptions, e.g: FormatException, ...
        exceptionHandler(exception, trace, alert: false);
        return handler.reject(dio.DioError(
          requestOptions: options,
          type: dio.DioErrorType.unknown,
        ));
      }
    }

    // If token is valid or failed to refresh, just proceed with request
    super.onRequest(options, handler);
  }

  @override
  void onResponse(dio.Response response, dio.ResponseInterceptorHandler handler) async {
    if (response.isSuccess) return super.onResponse(response, handler);

    final canRetry = _canAttemptRetry(response.requestOptions.headers);

    if (response.statusCode == status401Unauthorized && canRetry) {
      // Increment retry count
      response.requestOptions.headers[_attemptKey] ??= 0;
      response.requestOptions.headers[_attemptKey] += 1;

      if (isPathRetriable(response.realUri)) {
        await onRefreshToken();
      } else {
        // await UserRepository.shared.login();
      }

      final ac = getAccessToken();
      if (ac != null) {
        response.requestOptions.headers['Authorization'] = 'Bearer $ac';
        // response.requestOptions.headers['x-forwarded-authorization'] = 'Bearer $ac';

        try {
          final result = await onFetch(response.requestOptions);

          return super.onResponse(result, handler);
        } on dio.DioError catch (e) {
          if (e.type != dio.DioErrorType.cancel) return super.onResponse(response, handler);
        }
      }
    }

    return handler.reject(
      dio.DioError(
        error: response,
        requestOptions: response.requestOptions,
      ),
    );
  }
}
