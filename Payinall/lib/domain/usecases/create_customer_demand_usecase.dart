import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/create_customer_demand_params.dart';
import 'package:payinall/domain/repositories/customer_demands_repository.dart';

final class CreateCustomerDemandUsecase
    implements BaseUsecase<String, CreateCustomerDemandParams> {
  CreateCustomerDemandUsecase(this.repository);

  final CustomerDemandsRepository repository;

  @override
  Future<Either<Failure, String>> call(CreateCustomerDemandParams params) =>
      repository.createDemand(params);
}
