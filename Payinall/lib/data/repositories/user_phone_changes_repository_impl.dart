import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/user_phone_changes_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/change_phone_code_request.dart';
import 'package:payinall/data/dtos/requests/change_phone_request.dart';
import 'package:payinall/domain/base/data_with_message.dart';
import 'package:payinall/domain/params/change_phone_code_params.dart';
import 'package:payinall/domain/params/change_phone_params.dart';
import 'package:payinall/domain/repositories/user_phone_changes_repository.dart';

final class UserPhoneChangesRepositoryImpl
    implements UserPhoneChangesRepository {
  UserPhoneChangesRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final UserPhoneChangesRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, DataWithMessage<String>>> changePhoneCode(
    ChangePhoneCodeParams params,
  ) async {
    return _dataSourceHandler.handle<DataWithMessage<String>, String>(
      remoteFunction: () async {
        final request = ChangePhoneCodeRequest.fromParams(params);
        final result = await remoteDataSource.changePhoneCode(request);
        return result;
      },
    );
  }

  @override
  Future<Either<Failure, String>> changePhone(ChangePhoneParams params) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final request = ChangePhoneRequest.fromParams(params);
        final result = await remoteDataSource.changePhone(request);
        return result;
      },
      onlyMessage: true,
    );
  }
}
