import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/help.dart';

abstract interface class HelpsRepository {
  Future<Either<Failure, List<Help>>> getHelps();
}
