import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';

abstract interface class CustomersRepository {
  Future<Either<Failure, void>> logOut();
}
