import 'package:get_it/get_it.dart';
import 'package:payinall/data/network/config/network_config.dart';
import 'package:payinall/data/network/interceptors/network_interceptor.dart';
import 'package:payinall/data/network/interceptors/token_interceptor.dart';
import 'package:payinall/data/network/network_client.dart';
import 'package:payinall/data/network/network_info.dart';
import 'package:payinall/di/di_module.dart';

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
