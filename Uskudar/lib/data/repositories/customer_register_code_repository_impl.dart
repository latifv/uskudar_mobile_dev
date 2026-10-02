import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/customer_register_code_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/check_register_code_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/create_register_code_request.dart';
import 'package:uskudar_mobile/domain/base/data_with_message.dart';
import 'package:uskudar_mobile/domain/params/check_register_code_params.dart';
import 'package:uskudar_mobile/domain/params/create_register_code_params.dart';
import 'package:uskudar_mobile/domain/repositories/customer_register_code_repository.dart';

final class CustomerRegisterCodeRepositoryImpl
    implements CustomerRegisterCodeRepository {
  CustomerRegisterCodeRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final CustomerRegisterCodeRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, String>> checkRegisterCode(
    CheckRegisterCodeParams params,
  ) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final request = CheckRegisterCodeRequest.fromParams(params);
        final result = await remoteDataSource.checkRegisterCode(request);
        return result;
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, DataWithMessage<String>>> createRegisterCode(
    CreateRegisterCodeParams params,
  ) async {
    return _dataSourceHandler.handle<DataWithMessage<String>, String>(
      remoteFunction: () async {
        final request = CreateRegisterCodeRequest.fromParams(params);
        final result = await remoteDataSource.createRegisterCode(request);
        return result;
      },
    );
  }
}
