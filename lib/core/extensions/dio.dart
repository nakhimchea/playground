import 'package:dio/dio.dart' as dio;

extension DioExtension on dio.Response {
  bool get isSuccess => statusCode.toString().startsWith('2');
}
