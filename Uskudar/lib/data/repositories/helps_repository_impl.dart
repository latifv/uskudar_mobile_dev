import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/helps_remote_data_source.dart';
import 'package:uskudar_mobile/data/models/help_model.dart';
import 'package:uskudar_mobile/domain/entities/help.dart';
import 'package:uskudar_mobile/domain/repositories/helps_repository.dart';

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
