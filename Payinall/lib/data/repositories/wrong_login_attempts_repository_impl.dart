import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/wrong_login_attempts_remote_data_source.dart';
import 'package:payinall/data/models/wrong_password_history_model.dart';
import 'package:payinall/domain/entities/wrong_password_history.dart';
import 'package:payinall/domain/repositories/wrong_login_attempts_repository.dart';

final class WrongLoginAttemptsRepositoryImpl
    implements WrongLoginAttemptsRepository {
  WrongLoginAttemptsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final WrongLoginAttemptsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<WrongPasswordHistory>>>
  getCurrentCustomerWrongPasswordHistories() async {
    return _dataSourceHandler
        .handle<List<WrongPasswordHistory>, List<WrongPasswordHistoryModel>>(
          remoteFunction: () async {
            final result = await remoteDataSource
                .getCurrentCustomerWrongPasswordHistories();
            return result;
          },
          onlyData: true,
        );
  }
}
