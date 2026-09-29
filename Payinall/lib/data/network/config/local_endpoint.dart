/// Android's emulator host alias is not reachable from the iOS simulator.
String resolveLocalEndpoint(
  String url, {
  required bool isDebug,
  required bool isIOS,
}) {
  if (!isDebug || !isIOS) return url;
  final uri = Uri.tryParse(url);
  if (uri == null || uri.host != '10.0.2.2') return url;
  return uri.replace(host: '127.0.0.1').toString();
}
