import 'package:dio/dio.dart';
import 'package:uskudar_mobile/core/managers/token_manager.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';
import 'package:uskudar_mobile/core/utils/log_level.dart';
import 'package:uskudar_mobile/data/network/constants/header_constants.dart';

final class TokenInterceptor extends Interceptor {
  TokenInterceptor(this.tokenManager);

  final TokenManager tokenManager;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (tokenManager.hasValidToken && tokenManager.token != null) {
      options.headers[HeaderConstants.authorization] =
          '${HeaderConstants.bearer} ${tokenManager.token}';
      LogHelper.log(LogLevel.debug, 'Token eklendi: ${options.path}');
    } else {
      LogHelper.log(LogLevel.debug, 'Token bulunamadı: ${options.path}');
    }

    handler.next(options);
  }
}
