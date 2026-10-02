import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uskudar_mobile/data/network/models/network_connection_type.dart';

abstract interface class NetworkInfo {
  Future<bool> get isConnected;
  Future<List<NetworkConnectionType>> getCurrentConnectionTypes();
}

final class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl() {
    _connectivity = Connectivity();
  }

  late final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      return !result.contains(ConnectivityResult.none);
    } on Exception catch (_) {
      return true;
    }
  }

  @override
  Future<List<NetworkConnectionType>> getCurrentConnectionTypes() async {
    final connectivityResult = await _connectivity.checkConnectivity();

    return connectivityResult.map((result) {
      return switch (result) {
        ConnectivityResult.wifi => NetworkConnectionType.wifi,
        ConnectivityResult.mobile => NetworkConnectionType.mobile,
        ConnectivityResult.ethernet => NetworkConnectionType.ethernet,
        ConnectivityResult.bluetooth => NetworkConnectionType.bluetooth,
        ConnectivityResult.none => NetworkConnectionType.none,
        _ => NetworkConnectionType.unknown,
      };
    }).toList();
  }
}
