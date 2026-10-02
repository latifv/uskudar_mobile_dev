import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/login_attempts_remote_data_source.dart';
import 'package:payinall/data/models/last_login_model.dart';
import 'package:payinall/domain/entities/last_login.dart';
import 'package:payinall/domain/repositories/login_attempts_repository.dart';

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
