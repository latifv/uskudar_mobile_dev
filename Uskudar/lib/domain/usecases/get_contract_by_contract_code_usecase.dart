import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/contract.dart';
import 'package:payinall/domain/repositories/contracts_repository.dart';

final class GetContractByContractCodeUsecase
    implements BaseUsecase<Contract, String> {
  GetContractByContractCodeUsecase(this.repository);

  final ContractsRepository repository;

  @override
  Future<Either<Failure, Contract>> call(String contractCode) async {
    final result = await repository.getContractByContractCode(contractCode);
    return result;
  }
}
