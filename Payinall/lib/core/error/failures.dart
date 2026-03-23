import 'package:equatable/equatable.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

sealed class Failure extends Equatable {
  const Failure({String? message}) : _message = message;

  final String? _message;

  @override
  List<Object?> get props => [_message];
}

final class ServerFailure extends Failure {
  const ServerFailure({super.message, this.data});

  final dynamic data;

  @override
  List<Object?> get props => [_message, data];
}

final class DataFailure extends Failure {
  const DataFailure({super.message});

  @override
  List<Object?> get props => [_message];
}

final class CacheFailure extends Failure {
  const CacheFailure({super.message});

  @override
  List<Object?> get props => [_message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message});

  @override
  List<Object?> get props => [_message];
}

final class AuthFailure extends Failure {
  const AuthFailure({super.message});

  @override
  List<Object?> get props => [_message];
}

final class MappingFailure extends Failure {
  const MappingFailure({super.message});

  @override
  List<Object?> get props => [_message];
}

final class ValidationFailure extends Failure {
  const ValidationFailure({super.message});

  @override
  List<Object?> get props => [_message];
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure({super.message});

  @override
  List<Object?> get props => [_message];
}

extension FailureExtension on Failure {
  String get message {
    if (this is ServerFailure) {
      return _message ?? LocaleKeys.server_error.translate;
    } else if (this is CacheFailure) {
      return _message ?? LocaleKeys.cache_error.translate;
    } else if (this is NetworkFailure) {
      return _message ?? LocaleKeys.no_internet.translate;
    } else if (this is AuthFailure) {
      return _message ?? LocaleKeys.session_expired.translate;
    } else if (this is MappingFailure) {
      return _message ?? LocaleKeys.mapping_error.translate;
    } else if (this is ValidationFailure) {
      return _message ?? LocaleKeys.validation_error.translate;
    } else if (this is DataFailure) {
      return _message ?? LocaleKeys.data_error.translate;
    } else if (this is ForbiddenFailure) {
      return _message ?? LocaleKeys.forbidden_error.translate;
    }
    return _message ?? LocaleKeys.unknown_error.translate;
  }
}
