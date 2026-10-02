sealed class AppException implements Exception {
  const AppException([this.message]);

  final String? message;
  String get exceptionName => 'AppException';

  @override
  String toString() {
    return message == null ? exceptionName : '$exceptionName: $message';
  }
}

final class ServerException extends AppException {
  const ServerException([super.message, this.data]);

  final dynamic data;

  @override
  String get exceptionName => 'ServerException';
}

final class DataException extends AppException {
  const DataException([super.message]);
  @override
  String get exceptionName => 'DataException';
}

final class MappingException extends AppException {
  const MappingException([super.message]);
  @override
  String get exceptionName => 'MappingException';
}

final class CacheException extends AppException {
  const CacheException([super.message]);
  @override
  String get exceptionName => 'CacheException';
}

final class NetworkException extends AppException {
  const NetworkException([super.message]);
  @override
  String get exceptionName => 'NetworkException';
}

final class AuthException extends AppException {
  const AuthException([super.message]);
  @override
  String get exceptionName => 'AuthException';
}

final class ValidationException extends AppException {
  const ValidationException([super.message]);
  @override
  String get exceptionName => 'ValidationException';
}

final class ForbiddenException extends AppException {
  const ForbiddenException([super.message]);
  @override
  String get exceptionName => 'ForbiddenException';
}
