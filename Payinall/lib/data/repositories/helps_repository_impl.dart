import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/helps_remote_data_source.dart';
import 'package:payinall/data/models/help_model.dart';
import 'package:payinall/domain/entities/help.dart';
import 'package:payinall/domain/repositories/helps_repository.dart';

final class HelpsRepositoryImpl implements HelpsRepository {
  HelpsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final HelpsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<Help>>> getHelps() async {
    return _dataSourceHandler.handle<List<Help>, List<HelpModel>>(
      remoteFunction: () async {
        final result = await remoteDataSource.getHelps();
        return result;
      },
      onlyData: true,
    );
  }
}
