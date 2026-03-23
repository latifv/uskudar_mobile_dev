import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/local/app_local_data_source.dart';
import 'package:payinall/domain/repositories/app_repository.dart';

final class AppRepositoryImpl implements AppRepository {
  AppRepositoryImpl({required this.localDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final AppLocalDataSource localDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, bool>> getIsFirstRun() async {
    return _dataSourceHandler.handle<bool, bool>(
      localFunction: () async {
        final result = await localDataSource.getIsFirstRun();
        await localDataSource.setIsFirstRun();
        return result;
      },
    );
  }
}
