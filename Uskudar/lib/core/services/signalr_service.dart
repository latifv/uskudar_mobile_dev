import 'dart:async';

import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/utils/log_level.dart';
import 'package:payinall/data/network/config/api_constants.dart';
import 'package:signalr_netcore/signalr_client.dart';

abstract interface class SignalRService {
  Future<void> connect(String token);
  Future<void> disconnect();
  bool get isConnected;
  Stream<String> get onLogout;
  Future<void> dispose();
}

final class SignalRServiceImpl implements SignalRService {
  HubConnection? _hubConnection;
  final StreamController<String> _logoutController =
      StreamController<String>.broadcast();

  @override
  Stream<String> get onLogout => _logoutController.stream;

  @override
  bool get isConnected => _hubConnection?.state == HubConnectionState.Connected;

  @override
  Future<void> connect(String token) async {
    if (_hubConnection != null && isConnected) {
      return;
    }

    final hubUrl = ApiConstants.signalrUrl;
    LogHelper.log(LogLevel.info, 'SignalR bağlantı adresi: $hubUrl');

    try {
      _hubConnection = HubConnectionBuilder()
          .withUrl(
            hubUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token,
            ),
          )
          .withAutomaticReconnect()
          .build();

      await _hubConnection!.start();
      LogHelper.log(
        LogLevel.info,
        'SignalR bağlantısı başarılı - Adres: $hubUrl',
      );
    } catch (e) {
      LogHelper.log(
        LogLevel.error,
        'SignalR bağlantı hatası - Adres: $hubUrl, Hata: $e',
      );
      _hubConnection = null;
      rethrow;
    }

    _hubConnection!.on('ReceiveMessage', (_) {
      LogHelper.log(LogLevel.info, 'SignalR ReceiveMessage alındı');
      _logoutController.add('logout');
    });
  }

  @override
  Future<void> disconnect() async {
    if (_hubConnection != null) {
      try {
        await _hubConnection!.stop();
      } on Exception catch (e) {
        LogHelper.log(LogLevel.warning, 'SignalR disconnect hatası: $e');
      }
      _hubConnection = null;
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await disconnect().timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          LogHelper.log(LogLevel.warning, 'SignalR disconnect timeout');
          _hubConnection = null;
        },
      );

      if (!_logoutController.isClosed) {
        await _logoutController.close();
      }
    } on Exception catch (e) {
      LogHelper.log(LogLevel.error, 'SignalR dispose hatası: $e');
    }
  }
}
