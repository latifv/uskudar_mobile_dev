import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/wrong_password_history.dart';

abstract interface class WrongLoginAttemptsRepository {
  Future<Either<Failure, List<WrongPasswordHistory>>>
  getCurrentCustomerWrongPasswordHistories();
}
