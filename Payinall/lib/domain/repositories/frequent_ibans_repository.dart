import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/frequent_iban.dart';
import 'package:payinall/domain/params/add_frequent_iban_params.dart';

abstract interface class FrequentIbansRepository {
  Future<Either<Failure, List<FrequentIban>>> getFrequentIbans();
  Future<Either<Failure, String>> addFrequentIban(
    AddFrequentIbanParams params,
  );
  Future<Either<Failure, String>> deleteFrequentIban(String id);
}
