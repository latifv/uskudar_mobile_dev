import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/customer_bank.dart';
import 'package:uskudar_mobile/domain/repositories/customer_banks_repository.dart';

final class GetCustomerBanksUsecase
    implements BaseUsecaseWithoutParams<List<CustomerBank>> {
  GetCustomerBanksUsecase(this.repository);

  final CustomerBanksRepository repository;

  @override
  Future<Either<Failure, List<CustomerBank>>> call() async {
    final result = await repository.getBanks();
    return result;
  }
}
