import 'dart:convert';

import 'package:dio/dio.dart' as d;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:playground/core/flavor/app_config.dart';
import 'package:playground/core/service/api/interceptors/auth/auth_interceptor.dart';
import 'package:playground/core/service/api/interceptors/connectivity/connectivity_interceptor.dart';
import 'package:playground/core/service/api/interceptors/logger/logging_interceptor.dart';
import 'package:playground/core/service/token_service.dart';

import 'interceptors/retry/retry_interceptor.dart';

// Must be top-level function
dynamic _parseAndDecode(String response) => jsonDecode(response);
dynamic parseJson(String text) => compute(_parseAndDecode, text);

class ApiService extends GetxService {
  ApiService init() => this;

  String get baseUrl => AppConfig.shared.baseUrl;
  Logger get logger => Logger.root;
  TokenManager tokenManager = TokenManager();

  Future<d.Dio> _dioClient([int? retries]) async {
    final client = d.Dio(
      d.BaseOptions(
        followRedirects: false,
        contentType: 'application/json',
        responseType: d.ResponseType.json,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Charset': 'utf-8',
          // "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
          // 'x-api-key': AppConfig.shared.xSecretApi,
        },
        baseUrl: baseUrl,
        sendTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
        connectTimeout: const Duration(milliseconds: 10000),
        validateStatus: (status) => status != null && status <= 500,
      ),
    );
    // ignore: deprecated_member_use
    (client.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;

    // DO NOT change order of these interceptors
    client.interceptors.add(
      LoggingInterceptor(
        requestHeader: true,
        logPrint: (step, message) {
          switch (step) {
            case InterceptStep.request:
              logger.info(message);
              break;
            case InterceptStep.response:
              logger.info(message);
              break;
            case InterceptStep.error:
              logger.severe(message);
              break;
          }
        },
      ),
    );
    client.interceptors.add(InternetConnectivityInterceptor());

    client.interceptors.add(
      AuthenticationInterceptor(
        // getAccessToken: () => UserRepository.shared.accessToken,
        // onRefreshToken: () => UserRepository.shared.onRefreshToken(),
        getAccessToken: () => null, //tokenManager.getCurrentToken(),

        onRefreshToken: () async {},
        onFetch: (requestOptions) => fetch(requestOptions),
      ),
    );

    client.interceptors.add(
      RetryInterceptor(
        dio: client,
        logPrint: (message) => logger.info(message),
        retries: retries ?? 1,
        retryDelays: const [
          Duration(seconds: 1),
          // Duration(seconds: 3),
          // Duration(seconds: 5),
        ],
      ),
    );

    return client;
  }

  Future<d.Response> fetch(d.RequestOptions options) async {
    return (await _dioClient()).fetch(options);
  }

  Future<d.Response> get(
    String? path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    if (path == null) throw 'Path is null';
    final client = await _dioClient();

    if (headers != null) {
      for (MapEntry entry in headers.entries) {
        client.options.headers[entry.key] = entry.value;
      }
    }

    return client.get(
      path,
      queryParameters: queryParameters,
    );
  }

  Future<d.Response> post(
    String path,
    dynamic formData, {
    int? retries,
    String? baseUrl,
    bool encode = true,
    Map<String, dynamic>? cusHeaders,
  }) async {
    final client = await _dioClient(retries);
    // override default
    if (baseUrl != null) client.options.baseUrl = baseUrl;

    if (cusHeaders != null) {
      client.options.headers.addEntries(cusHeaders.entries);
    }

    return client.post(
      path,
      data: formData is d.FormData
          ? formData
          : encode
              ? jsonEncode(formData)
              : formData,
    );
  }

  Future<d.Response> put(
    String path, {
    dynamic formData,
  }) async {
    final client = await _dioClient();

    return client.put(
      path,
      data: formData is d.FormData ? formData : jsonEncode(formData),
    );
  }

  Future<d.Response> delete(
    String path, {
    dynamic data,
  }) async {
    final client = await _dioClient();

    return client.delete(path, data: data);
  }

  Future<d.Response> patch(
    String path, {
    dynamic formData,
  }) async {
    final client = await _dioClient();

    return client.patch(
      path,
      data: formData is d.FormData ? formData : jsonEncode(formData),
    );
  }
}
