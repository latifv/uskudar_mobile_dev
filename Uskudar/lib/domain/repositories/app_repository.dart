import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';

abstract interface class AppRepository {
  Future<Either<Failure, bool>> getIsFirstRun();
}
