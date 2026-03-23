import 'package:payinall/data/config/environment_config.dart';

final class ApiConstants {
  const ApiConstants._();

  static final String baseUrl = EnvironmentConfig.values.apiUrl;
  static final String signalrUrl = EnvironmentConfig.values.signalrUrl;
}
