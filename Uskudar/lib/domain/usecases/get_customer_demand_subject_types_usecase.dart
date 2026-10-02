import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/customer_demand_subject.dart';
import 'package:payinall/domain/repositories/customer_demands_repository.dart';

final class GetCustomerDemandSubjectTypesUsecase
    implements BaseUsecaseWithoutParams<List<CustomerDemandSubject>> {
  GetCustomerDemandSubjectTypesUsecase(this.repository);

  final CustomerDemandsRepository repository;

  @override
  Future<Either<Failure, List<CustomerDemandSubject>>> call() =>
      repository.getSubjectTypes();
}
