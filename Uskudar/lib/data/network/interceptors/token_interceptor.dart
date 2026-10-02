import 'package:dio/dio.dart';
import 'package:payinall/core/managers/token_manager.dart';
import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/utils/log_level.dart';
import 'package:payinall/data/network/constants/header_constants.dart';

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
