import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/managers/token_manager.dart';
import 'package:uskudar_mobile/core/services/signalr_service.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';
import 'package:uskudar_mobile/core/utils/log_level.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/usecases/logout_usecase.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

abstract interface class SignalRManager {
  Future<void> initializeAndConnect();
  Future<void> disconnect();
  Future<void> dispose();
}

final class SignalRManagerImpl implements SignalRManager {
  SignalRManagerImpl({
    required SignalRService signalRService,
    required TokenManager tokenManager,
  }) : _signalRService = signalRService,
       _tokenManager = tokenManager;

  final SignalRService _signalRService;
  final TokenManager _tokenManager;
  StreamSubscription<String>? _logoutSubscription;

  @override
  Future<void> initializeAndConnect() async {
    if (_signalRService.isConnected) {
      LogHelper.log(
        LogLevel.info,
        'SignalR zaten bağlı - yeniden başlatılmadı',
      );
      return;
    }

    if (!_tokenManager.hasValidToken || _tokenManager.token == null) {
      LogHelper.log(
        LogLevel.warning,
        'Auth token bulunamadı - SignalR başlatılamadı',
      );
      return;
    }

    try {
      LogHelper.log(LogLevel.info, 'SignalR bağlantısı başlatılıyor...');
      await _signalRService.connect(_tokenManager.token!);
      LogHelper.log(LogLevel.info, 'SignalR başarıyla bağlandı');

      _logoutSubscription = _signalRService.onLogout.listen(
        _handleLogoutEvent,
        onError: (Object error) {
          LogHelper.log(LogLevel.error, 'SignalR çıkış akış hatası: $error');
        },
      );
    } catch (e) {
      LogHelper.log(LogLevel.error, 'SignalR bağlantı hatası: $e');
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    if (!_signalRService.isConnected && _logoutSubscription == null) {
      LogHelper.log(
        LogLevel.debug,
        'SignalR zaten bağlantısı kesilmiş durumda',
      );
      return;
    }

    if (_logoutSubscription != null) {
      await _logoutSubscription!.cancel();
      _logoutSubscription = null;
      LogHelper.log(LogLevel.debug, 'SignalR logout subscription iptal edildi');
    }

    if (_signalRService.isConnected) {
      await _signalRService.disconnect();
      LogHelper.log(LogLevel.info, 'SignalR bağlantısı kesildi');
    }
  }

  @override
  Future<void> dispose() async {
    LogHelper.log(LogLevel.debug, 'SignalR Manager dispose ediliyor...');
    await disconnect();
    await _signalRService.dispose();
    LogHelper.log(LogLevel.debug, 'SignalR Manager dispose edildi');
  }

  Future<void> _handleLogoutEvent(String event) async {
    final logoutUsecase = getIt<LogoutUsecase>();
    await logoutUsecase();

    final appRouter = getIt<AppRouter>();
    final navigatorKey = appRouter.navigatorKey;

    if (navigatorKey.currentContext != null) {
      final context = navigatorKey.currentContext!;
      if (context.mounted) {
        unawaited(
          context.router.replaceAll([
            LoginRoute(
              notAcceptableMessage: LocaleKeys.another_device_login.translate,
            ),
          ]),
        );
      }
    }
  }
}
