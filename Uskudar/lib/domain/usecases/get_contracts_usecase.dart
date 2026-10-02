import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/contract.dart';
import 'package:uskudar_mobile/domain/repositories/contracts_repository.dart';

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
