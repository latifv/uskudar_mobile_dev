import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/local/customers_local_data_source.dart';
import 'package:payinall/data/datasources/remote/customers_remote_data_source.dart';
import 'package:payinall/domain/repositories/customers_repository.dart';

final class CustomersRepositoryImpl implements CustomersRepository {
  CustomersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  }) : _dataSourceHandler = DataSourceHandler();

  final CustomersRemoteDataSource remoteDataSource;
  final CustomersLocalDataSource localDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, void>> logOut() async {
    return _dataSourceHandler.handle<void, void>(
      localFunction: () async {
        await localDataSource.logOut();
      },
      onlyResponseType: true,
    );
  }
}
