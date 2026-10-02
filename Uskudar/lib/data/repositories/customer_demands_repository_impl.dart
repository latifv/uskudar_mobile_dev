import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/customer_demands_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/create_customer_demand_request.dart';
import 'package:payinall/data/models/customer_demand_subject_model.dart';
import 'package:payinall/domain/entities/customer_demand_subject.dart';
import 'package:payinall/domain/params/create_customer_demand_params.dart';
import 'package:payinall/domain/repositories/customer_demands_repository.dart';

final class CustomerDemandsRepositoryImpl implements CustomerDemandsRepository {
  CustomerDemandsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final CustomerDemandsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<CustomerDemandSubject>>> getSubjectTypes() async {
    return _dataSourceHandler
        .handle<List<CustomerDemandSubject>, List<CustomerDemandSubjectModel>>(
          remoteFunction: () async {
            final result = await remoteDataSource.getSubjectTypes();
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, String>> createDemand(
    CreateCustomerDemandParams params,
  ) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final request = CreateCustomerDemandRequest.fromParams(params);
        final result = await remoteDataSource.createDemand(request);
        return result;
      },
      onlyMessage: true,
    );
  }
}
