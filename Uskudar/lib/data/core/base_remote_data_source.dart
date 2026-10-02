import 'package:uskudar_mobile/data/network/network_client.dart';

abstract class BaseRemoteDataSource {
  BaseRemoteDataSource(this.networkClient);

  final NetworkClient networkClient;

  Future<dynamic> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    return networkClient.getResponse(
      endpoint: endpoint,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> post({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return networkClient.postResponse(
      endpoint: endpoint,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> put({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return networkClient.putResponse(
      endpoint: endpoint,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> delete({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return networkClient.deleteResponse(
      endpoint: endpoint,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> patch({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return networkClient.patchResponse(
      endpoint: endpoint,
      data: data,
      queryParameters: queryParameters,
    );
  }
}
