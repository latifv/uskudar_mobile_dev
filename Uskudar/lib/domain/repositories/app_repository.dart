import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';

abstract interface class AppRepository {
  Future<Either<Failure, bool>> getIsFirstRun();
}
