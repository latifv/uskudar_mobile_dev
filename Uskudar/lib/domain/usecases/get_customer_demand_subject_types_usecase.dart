import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/customer_demand_subject.dart';
import 'package:uskudar_mobile/domain/repositories/customer_demands_repository.dart';

final class GetCustomerDemandSubjectTypesUsecase
    implements BaseUsecaseWithoutParams<List<CustomerDemandSubject>> {
  GetCustomerDemandSubjectTypesUsecase(this.repository);

  final CustomerDemandsRepository repository;

  @override
  Future<Either<Failure, List<CustomerDemandSubject>>> call() =>
      repository.getSubjectTypes();
}
