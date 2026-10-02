import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uskudar_mobile/core/services/paycore_mobile_service.dart';
import 'package:uskudar_mobile/data/network/config/network_config.dart';
import 'package:uskudar_mobile/data/network/interceptors/network_interceptor.dart';
import 'package:uskudar_mobile/data/network/network_client.dart';
import 'package:uskudar_mobile/di/di.dart';

class RecordingAdapter implements HttpClientAdapter {
  final requests = <Uri>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options.uri);
    return ResponseBody.fromString(
      '{"data":null,"isSuccess":false,"message":"Synthetic response"}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('card list and customer info use the configured API', () async {
    getIt.registerSingleton<NetworkInterceptor>(const NetworkInterceptor());
    addTearDown(getIt.reset);
    final client = NetworkClient.withConfig(
      NetworkConfig.withCustomApiUrl(
        'https://example.invalid/api',
      ),
    );
    client.interceptors.clear();
    final adapter = RecordingAdapter();
    client.httpClientAdapter = adapter;
    addTearDown(() => client.close(force: true));
    final service = PaycoreMobileService(client);
    await service.getMyCards();
    await service.getCustomerInfo();
    expect(adapter.requests.map((uri) => uri.toString()).toList(), [
      'https://example.invalid/api/PayCoreCards/my-cards',
      'https://example.invalid/api/PayCoreCards/customer-info',
    ]);
  });
}
