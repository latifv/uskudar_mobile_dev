import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';

abstract interface class BaseUsecaseWithoutParams<Response> {
  Future<Either<Failure, Response>> call();
}
