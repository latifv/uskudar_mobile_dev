import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';

abstract interface class BaseUsecaseWithoutParams<Response> {
  Future<Either<Failure, Response>> call();
}
