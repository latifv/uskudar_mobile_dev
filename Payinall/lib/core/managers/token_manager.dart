import 'package:payinall/domain/entities/auth_token.dart';

final class TokenManager {
  String? _token;
  DateTime? _expiration;
  int? _endDateMinute;

  String? get token => _token;
  DateTime? get expiration => _expiration;
  int? get endDateMinute => _endDateMinute;

  bool get hasValidToken {
    if (_token == null || _token!.isEmpty) {
      return false;
    }
    if (_expiration == null) {
      return false;
    }

    final now = DateTime.now();
    final isValid = now.isBefore(_expiration!);
    return isValid;
  }

  void setToken(AuthToken authToken) {
    _token = authToken.token;
    _expiration = authToken.expiration;
    _endDateMinute = authToken.endDateMinute;
  }

  void clearToken() {
    _token = null;
    _expiration = null;
    _endDateMinute = null;
  }

  AuthToken? getAuthToken() {
    if (_token == null || _expiration == null || _endDateMinute == null) {
      return null;
    }

    return AuthToken(
      token: _token!,
      expiration: _expiration!,
      endDateMinute: _endDateMinute!,
    );
  }

  bool isTokenExpired() {
    if (_expiration == null) return true;
    return DateTime.now().isAfter(_expiration!);
  }

  bool isTokenExpiringSoon({int minutesThreshold = 5}) {
    if (_expiration == null) return true;
    final thresholdTime = DateTime.now().add(
      Duration(minutes: minutesThreshold),
    );
    return _expiration!.isBefore(thresholdTime);
  }
}
