import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/contract.dart';

abstract interface class ContractsRepository {
  Future<Either<Failure, List<Contract>>> getContracts();
  Future<Either<Failure, Contract>> getContractByContractCode(
    String contractCode,
  );
}
