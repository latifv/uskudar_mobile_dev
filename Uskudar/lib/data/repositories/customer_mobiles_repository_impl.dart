import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/customer_mobiles_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/customer_mobiles_request.dart';
import 'package:payinall/domain/params/customer_mobiles_params.dart';
import 'package:payinall/domain/repositories/customer_mobiles_repository.dart';

final class CustomerMobilesRepositoryImpl implements CustomerMobilesRepository {
  CustomerMobilesRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final CustomerMobilesRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, void>> customerMobiles(
    CustomerMobilesParams params,
  ) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final request = CustomerMobilesRequest.fromParams(params);
        final result = await remoteDataSource.customerMobiles(request);
        return result;
      },
      onlyResponseType: true,
    );
  }
}
