import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;

import '../../../../llibraries/connectivity_plus.dart';

class InternetConnectivityInterceptor extends dio.Interceptor {
  InternetConnectivityInterceptor();

  final _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivityListener;

  @override
  void onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) async {
    final status = await _connectivity.checkConnectivity();

    // If connected, proceed with request
    if (ConnectivityPlusManager.shared.isConnectedWithStatus(status)) {
      return super.onRequest(options, handler);
    }

    // Listen for status changes
    _connectivityListener = _connectivity.onConnectivityChanged.listen((events) {
      if (ConnectivityPlusManager.shared.isConnectedWithStatus(events)) {
        _connectivityListener?.cancel();
        super.onRequest(options, handler);
      }
    });
  }

  @override
  void onResponse(dio.Response response, dio.ResponseInterceptorHandler handler) {
    _connectivityListener?.cancel();

    super.onResponse(response, handler);
  }

  @override
  void onError(dio.DioError err, dio.ErrorInterceptorHandler handler) {
    _connectivityListener?.cancel();

    super.onError(err, handler);
  }
}
