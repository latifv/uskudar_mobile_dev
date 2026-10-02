import 'package:flutter/foundation.dart';
import 'package:uskudar_mobile/data/config/environment_config.dart';
import 'package:uskudar_mobile/data/network/config/local_endpoint.dart';

final class ApiConstants {
  const ApiConstants._();

  static String _resolve(String url) => resolveLocalEndpoint(
    url,
    isDebug: kDebugMode,
    isIOS: !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS,
  );
  static final String baseUrl = _resolve(EnvironmentConfig.values.apiUrl);
  static final String signalrUrl = _resolve(EnvironmentConfig.values.signalrUrl);
}
