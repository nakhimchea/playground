import 'package:dio/dio.dart' as dio;

dynamic getPropertyFromJson(dynamic data, String? key) {
  if (data == null || key == null) return null;

  final arr = key.split('.');

  dynamic cp = data;
  for (var key in arr) {
    if (cp is Map && cp.containsKey(key)) {
      cp = cp[key];
    } else {
      return null;
    }
  }
  return cp;
}

String? getResponseMessage(response, {String? lang}) {
  if (response is dio.Response) {
    if (response.data == null) return null;

    return response.data['message_$lang'] ?? response.data['message'] ?? '';
  } else if (response is dio.DioError) {
    final data = response.response?.data ?? (response.error is dio.Response ? (response.error as dio.Response).data : response.error);

    final content = data is Map ? data['message_$lang'] ?? data['message'] ?? data['result_message'] ?? data['error'] ?? response.message : null;
    return content;
  }

  return null;
}
