import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';

abstract interface class CustomersRepository {
  Future<Either<Failure, void>> logOut();
}
