import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/customer_demand_subject.dart';
import 'package:payinall/domain/params/create_customer_demand_params.dart';

abstract interface class CustomerDemandsRepository {
  Future<Either<Failure, List<CustomerDemandSubject>>> getSubjectTypes();
  Future<Either<Failure, String>> createDemand(
    CreateCustomerDemandParams params,
  );
}
