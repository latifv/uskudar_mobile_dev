import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';

abstract interface class BaseUsecase<Response, Params> {
  Future<Either<Failure, Response>> call(Params params);
}
