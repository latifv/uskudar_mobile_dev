import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/last_login.dart';

abstract interface class LoginAttemptsRepository {
  Future<Either<Failure, List<LastLogin>>> getLastLogin();
}
