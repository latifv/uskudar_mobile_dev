import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/user_phone_changes_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/change_phone_code_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/change_phone_request.dart';
import 'package:uskudar_mobile/domain/base/data_with_message.dart';
import 'package:uskudar_mobile/domain/params/change_phone_code_params.dart';
import 'package:uskudar_mobile/domain/params/change_phone_params.dart';
import 'package:uskudar_mobile/domain/repositories/user_phone_changes_repository.dart';

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
