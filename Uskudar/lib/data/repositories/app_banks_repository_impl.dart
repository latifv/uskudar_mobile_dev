import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/app_banks_remote_data_source.dart';
import 'package:uskudar_mobile/data/models/app_bank_model.dart';
import 'package:uskudar_mobile/domain/entities/app_bank.dart';
import 'package:uskudar_mobile/domain/repositories/app_banks_repository.dart';

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
