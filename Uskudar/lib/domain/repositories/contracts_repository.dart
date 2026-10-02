import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/contract.dart';

abstract interface class ContractsRepository {
  Future<Either<Failure, List<Contract>>> getContracts();
  Future<Either<Failure, Contract>> getContractByContractCode(
    String contractCode,
  );
}
