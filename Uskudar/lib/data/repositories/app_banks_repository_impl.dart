import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/app_banks_remote_data_source.dart';
import 'package:payinall/data/models/app_bank_model.dart';
import 'package:payinall/domain/entities/app_bank.dart';
import 'package:payinall/domain/repositories/app_banks_repository.dart';

final class AppBanksRepositoryImpl implements AppBanksRepository {
  AppBanksRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final AppBanksRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<AppBank>>> getActives() async {
    return _dataSourceHandler.handle<List<AppBank>, List<AppBankModel>>(
      remoteFunction: () async {
        final result = await remoteDataSource.getActives();
        return result;
      },
      onlyData: true,
    );
  }
}
