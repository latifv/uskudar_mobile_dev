import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:payinall/data/datasources/local/app_local_data_source.dart';
import 'package:payinall/data/network/constants/header_constants.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/usecases/logout_usecase.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/route/route_paths.dart';

final class NetworkInterceptor extends Interceptor {
  const NetworkInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final appLocalDataSource = getIt<AppLocalDataSource>();
      final savedLanguage = await appLocalDataSource.getSelectedLanguage();

      final languageCode =
          savedLanguage ?? Platform.localeName.split('_').first;
      options.headers[HeaderConstants.xLanguage] = languageCode;
    } on Exception catch (_) {
      final deviceLocale = Platform.localeName.split('_').first;
      options.headers[HeaderConstants.xLanguage] = deviceLocale;
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      unawaited(_handleUnauthorizedError());
      return;
    }
    if (err.response?.statusCode == HttpStatus.notAcceptable) {
      unawaited(_handleNotAcceptableError(err.response));
    }
    handler.next(err);
  }

  Future<void> _handleUnauthorizedError() async {
    final logoutUsecase = getIt<LogoutUsecase>();
    await logoutUsecase();
    final appRouter = getIt<AppRouter>();
    final navigatorKey = appRouter.navigatorKey;

    if (navigatorKey.currentContext != null) {
      final context = navigatorKey.currentContext!;
      if (context.mounted) {
        final currentRoute = context.router.currentPath;

        if (currentRoute != RoutePaths.login &&
            currentRoute != RoutePaths.sessionExpired) {
          unawaited(context.router.replaceAll([const SessionExpiredRoute()]));
        }
      }
    }
  }

  Future<void> _handleNotAcceptableError(Response<dynamic>? response) async {
    final appRouter = getIt<AppRouter>();
    final navigatorKey = appRouter.navigatorKey;

    if (navigatorKey.currentContext != null) {
      final context = navigatorKey.currentContext!;
      if (context.mounted) {
        String? message;
        if (response?.data is Map<String, dynamic>) {
          final data = response!.data as Map<String, dynamic>;
          message =
              (data['message'] as String?) ?? (data['Message'] as String?);
        }

        final logoutUsecase = getIt<LogoutUsecase>();
        await logoutUsecase();

        if (context.mounted) {
          final currentRoute = context.router.currentPath;
          if (currentRoute != RoutePaths.login) {
            await context.router.replaceAll([
              LoginRoute(notAcceptableMessage: message),
            ]);
          }
        }
      }
    }
  }
}
