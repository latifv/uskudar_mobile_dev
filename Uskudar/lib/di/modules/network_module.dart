import 'package:get_it/get_it.dart';
import 'package:uskudar_mobile/data/network/config/network_config.dart';
import 'package:uskudar_mobile/data/network/interceptors/network_interceptor.dart';
import 'package:uskudar_mobile/data/network/interceptors/token_interceptor.dart';
import 'package:uskudar_mobile/data/network/network_client.dart';
import 'package:uskudar_mobile/data/network/network_info.dart';
import 'package:uskudar_mobile/di/di_module.dart';

final class NetworkModule extends DIModule {
  @override
  Future<void> setup(GetIt getIt) async {
    getIt
      ..registerSingleton<TokenInterceptor>(TokenInterceptor(getIt()))
      ..registerSingleton<NetworkInterceptor>(const NetworkInterceptor())
      ..registerSingleton<NetworkInfo>(NetworkInfoImpl())
      ..registerSingleton<NetworkConfig>(NetworkConfig.defaultConfig())
      ..registerSingleton<NetworkClient>(
        _createNetworkClient(getIt())..addTokenInterceptor(getIt()),
      );
  }

  NetworkClient _createNetworkClient(
    NetworkConfig config, {
    Map<String, dynamic>? headers,
  }) {
    final client = NetworkClient.withConfig(config);

    if (headers != null) {
      client.options.headers.addAll(headers);
    }

    return client;
  }
}
