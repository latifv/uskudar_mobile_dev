import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/contract.dart';
import 'package:payinall/domain/repositories/contracts_repository.dart';

final class GetContractsUsecase
    implements BaseUsecaseWithoutParams<List<Contract>> {
  GetContractsUsecase(this.repository);

  final ContractsRepository repository;

  @override
  Future<Either<Failure, List<Contract>>> call() async {
    final result = await repository.getContracts();
    return result;
  }
}
