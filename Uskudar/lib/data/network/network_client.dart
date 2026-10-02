import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';
import 'package:uskudar_mobile/core/utils/log_level.dart';
import 'package:uskudar_mobile/data/network/config/network_config.dart';
import 'package:uskudar_mobile/data/network/constants/header_constants.dart';
import 'package:uskudar_mobile/data/network/interceptors/network_interceptor.dart';
import 'package:uskudar_mobile/data/network/interceptors/token_interceptor.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final class NetworkClient with DioMixin implements Dio {
  factory NetworkClient() => NetworkClient._internal();

  NetworkClient._internal([BaseOptions? options]) {
    options = options ?? _createDefaultOptions();
    this.options = options;
    httpClientAdapter = IOHttpClientAdapter();
    _addInterceptors();
  }

  factory NetworkClient.withConfig(NetworkConfig config) {
    final options = BaseOptions(
      baseUrl: config.baseUrl,
      contentType: config.contentType,
      connectTimeout: Duration(milliseconds: config.connectTimeout),
      receiveTimeout: Duration(milliseconds: config.receiveTimeout),
      sendTimeout: Duration(milliseconds: config.sendTimeout),
      headers: {
        HeaderConstants.contentType: config.contentType,
        HeaderConstants.accept: config.accept,
      },
    );

    return NetworkClient._internal(options);
  }

  BaseOptions _createDefaultOptions() {
    final config = NetworkConfig.defaultConfig();
    return BaseOptions(
      baseUrl: config.baseUrl,
      contentType: config.contentType,
      connectTimeout: Duration(milliseconds: config.connectTimeout),
      receiveTimeout: Duration(milliseconds: config.receiveTimeout),
      sendTimeout: Duration(milliseconds: config.sendTimeout),
      headers: {
        HeaderConstants.contentType: config.contentType,
        HeaderConstants.accept: config.accept,
      },
    );
  }

  void _addInterceptors() {
    interceptors.addAll([
      getIt<NetworkInterceptor>(),
      if (kDebugMode)
        PrettyDioLogger(
          //! Arksigner kontrol edilecekse yorum yapın yoksa loglar sıkıntı çıkarıyor base64 gönderildiği için (requestBody)
          requestBody: true,
          requestHeader: true,
          logPrint: (log) => LogHelper.log(LogLevel.debug, log.toString()),
        ),
    ]);
  }

  void addTokenInterceptor(TokenInterceptor interceptor) {
    interceptors
      ..removeWhere((i) => i is TokenInterceptor)
      ..insert(0, interceptor);
    LogHelper.log(LogLevel.debug, 'TokenInterceptor eklendi');
  }

  CancelToken createCancelToken() {
    return CancelToken();
  }

  void cancelRequest(CancelToken token) {
    if (!token.isCancelled) {
      token.cancel(LocaleKeys.cancel_request.translate);
    }
  }

  Map<String, dynamic> _processError(DioException error) {
    if (error.type == DioExceptionType.badResponse &&
        error.response?.data is Map<String, dynamic>) {
      final responseData = error.response?.data as Map<String, dynamic>;
      return responseData;
    }

    if (error.error is HandshakeException ||
        error.error.toString().contains('CERTIFICATE_VERIFY_FAILED')) {
      LogHelper.log(LogLevel.error, 'SSL Sertifika Hatası: ${error.error}');
      return {
        'isSuccess': false,
        'message': LocaleKeys.ssl_error.translate,
      };
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => {
        'isSuccess': false,
        'message': LocaleKeys.connection_timeout.translate,
      },
      DioExceptionType.connectionError => {
        'isSuccess': false,
        'message': LocaleKeys.no_internet.translate,
      },
      _ => {'isSuccess': false, 'message': LocaleKeys.server_error.translate},
    };
  }

  Future<dynamic> _requestWithResponse({
    required String method,
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await request<dynamic>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
        cancelToken: cancelToken,
      );

      return response.data;
    } on DioException catch (e) {
      LogHelper.log(LogLevel.error, 'DioException hatası: $e');
      return _processError(e);
    }
  }

  Future<dynamic> getResponse({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) => _requestWithResponse(
    method: 'GET',
    endpoint: endpoint,
    queryParameters: queryParameters,
    cancelToken: cancelToken,
  );

  Future<dynamic> postResponse({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) => _requestWithResponse(
    method: 'POST',
    endpoint: endpoint,
    data: data,
    queryParameters: queryParameters,
    cancelToken: cancelToken,
  );

  Future<dynamic> putResponse({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) => _requestWithResponse(
    method: 'PUT',
    endpoint: endpoint,
    data: data,
    queryParameters: queryParameters,
    cancelToken: cancelToken,
  );

  Future<dynamic> deleteResponse({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) => _requestWithResponse(
    method: 'DELETE',
    endpoint: endpoint,
    data: data,
    queryParameters: queryParameters,
    cancelToken: cancelToken,
  );

  Future<dynamic> patchResponse({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) => _requestWithResponse(
    method: 'PATCH',
    endpoint: endpoint,
    data: data,
    queryParameters: queryParameters,
    cancelToken: cancelToken,
  );

  void dispose() {
    httpClientAdapter.close();
    close(force: true);
  }
}
