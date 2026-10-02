import 'package:uskudar_mobile/data/network/config/api_constants.dart';
import 'package:uskudar_mobile/data/network/constants/header_constants.dart';
import 'package:uskudar_mobile/data/network/constants/timeout_constants.dart';

final class NetworkConfig {
  const NetworkConfig({
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.sendTimeout,
    required this.contentType,
    required this.accept,
  });

  factory NetworkConfig.defaultConfig() {
    return NetworkConfig(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: TimeoutConstants.toMilliseconds(TimeoutConstants.connect),
      receiveTimeout: TimeoutConstants.toMilliseconds(TimeoutConstants.receive),
      sendTimeout: TimeoutConstants.toMilliseconds(TimeoutConstants.send),
      contentType: HeaderConstants.jsonContentType,
      accept: HeaderConstants.jsonContentType,
    );
  }

  factory NetworkConfig.withCustomApiUrl(String baseUrl) {
    return NetworkConfig(
      baseUrl: baseUrl,
      connectTimeout: TimeoutConstants.toMilliseconds(TimeoutConstants.connect),
      receiveTimeout: TimeoutConstants.toMilliseconds(TimeoutConstants.receive),
      sendTimeout: TimeoutConstants.toMilliseconds(TimeoutConstants.send),
      contentType: HeaderConstants.jsonContentType,
      accept: HeaderConstants.jsonContentType,
    );
  }

  final String baseUrl;
  final int connectTimeout;
  final int receiveTimeout;
  final int sendTimeout;
  final String contentType;
  final String accept;
}
