import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/contract.dart';
import 'package:uskudar_mobile/domain/repositories/contracts_repository.dart';

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
