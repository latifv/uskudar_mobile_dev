import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/create_customer_demand_params.dart';
import 'package:uskudar_mobile/domain/repositories/customer_demands_repository.dart';

final class CreateCustomerDemandUsecase
    implements BaseUsecase<String, CreateCustomerDemandParams> {
  CreateCustomerDemandUsecase(this.repository);

  final CustomerDemandsRepository repository;

  @override
  Future<Either<Failure, String>> call(CreateCustomerDemandParams params) =>
      repository.createDemand(params);
}
