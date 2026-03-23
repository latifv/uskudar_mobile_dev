import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/help.dart';

abstract interface class HelpsRepository {
  Future<Either<Failure, List<Help>>> getHelps();
}
