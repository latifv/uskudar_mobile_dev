import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/frequently_sent.dart';

abstract interface class FrequentlySentsRepository {
  Future<Either<Failure, List<FrequentlySent>>> getFrequentlySents();
  Future<Either<Failure, String>> addFrequentlySent(String customerNumber);
  Future<Either<Failure, String>> deleteFrequentlySent(int id);
}
