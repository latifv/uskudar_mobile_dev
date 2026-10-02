import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/wrong_password_history.dart';

abstract interface class WrongLoginAttemptsRepository {
  Future<Either<Failure, List<WrongPasswordHistory>>>
  getCurrentCustomerWrongPasswordHistories();
}
