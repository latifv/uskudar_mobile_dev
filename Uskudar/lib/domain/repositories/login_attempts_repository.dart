import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/last_login.dart';

abstract interface class LoginAttemptsRepository {
  Future<Either<Failure, List<LastLogin>>> getLastLogin();
}
