import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/login_attempts_remote_data_source.dart';
import 'package:uskudar_mobile/data/models/last_login_model.dart';
import 'package:uskudar_mobile/domain/entities/last_login.dart';
import 'package:uskudar_mobile/domain/repositories/login_attempts_repository.dart';

final class LoginAttemptsRepositoryImpl implements LoginAttemptsRepository {
  LoginAttemptsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final LoginAttemptsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<LastLogin>>> getLastLogin() async {
    return _dataSourceHandler.handle<List<LastLogin>, List<LastLoginModel>>(
      remoteFunction: () async {
        final result = await remoteDataSource.getLastLogin();
        return result;
      },
      onlyData: true,
    );
  }
}
