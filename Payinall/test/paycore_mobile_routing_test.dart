import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payinall/core/services/paycore_mobile_service.dart';
import 'package:payinall/data/network/config/network_config.dart';
import 'package:payinall/data/network/interceptors/network_interceptor.dart';
import 'package:payinall/data/network/network_client.dart';
import 'package:payinall/di/di.dart';

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
  test('card list and customer info stay on the mobile live API', () async {
    getIt.registerSingleton<NetworkInterceptor>(const NetworkInterceptor());
    addTearDown(getIt.reset);
    final client = NetworkClient.withConfig(
      NetworkConfig.withCustomApiUrl(
        'https://payinallwalletapi.erpapay.com/api',
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
      'https://payinallwalletapi.erpapay.com/api/PayCoreCards/my-cards',
      'https://payinallwalletapi.erpapay.com/api/PayCoreCards/customer-info',
    ]);
  });
}
