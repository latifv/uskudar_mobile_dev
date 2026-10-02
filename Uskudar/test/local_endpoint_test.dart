import 'package:flutter_test/flutter_test.dart';
import 'package:uskudar_mobile/data/network/config/local_endpoint.dart';

void main() {
  test('iOS debug preserves local API port and path', () {
    expect(
      resolveLocalEndpoint(
        'http://10.0.2.2:5093/api',
        isDebug: true,
        isIOS: true,
      ),
      'http://127.0.0.1:5093/api',
    );
  });

  test('Android and release URLs remain unchanged', () {
    for (final flags in [(true, false), (false, true)]) {
      expect(
        resolveLocalEndpoint(
          'http://10.0.2.2:5093/api',
          isDebug: flags.$1,
          isIOS: flags.$2,
        ),
        'http://10.0.2.2:5093/api',
      );
    }
    expect(
      resolveLocalEndpoint(
        'https://example.com/api',
        isDebug: true,
        isIOS: true,
      ),
      'https://example.com/api',
    );
  });
}
