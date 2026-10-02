import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/customer_register_code_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/check_register_code_request.dart';
import 'package:payinall/data/dtos/requests/create_register_code_request.dart';
import 'package:payinall/domain/base/data_with_message.dart';
import 'package:payinall/domain/params/check_register_code_params.dart';
import 'package:payinall/domain/params/create_register_code_params.dart';
import 'package:payinall/domain/repositories/customer_register_code_repository.dart';

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
