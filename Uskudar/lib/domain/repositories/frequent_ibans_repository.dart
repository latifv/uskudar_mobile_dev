import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/frequent_iban.dart';
import 'package:uskudar_mobile/domain/params/add_frequent_iban_params.dart';

abstract interface class FrequentIbansRepository {
  Future<Either<Failure, List<FrequentIban>>> getFrequentIbans();
  Future<Either<Failure, String>> addFrequentIban(
    AddFrequentIbanParams params,
  );
  Future<Either<Failure, String>> deleteFrequentIban(String id);
}
