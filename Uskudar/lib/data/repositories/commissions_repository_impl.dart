import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/commissions_remote_data_source.dart';
import 'package:payinall/data/models/commission_model.dart';
import 'package:payinall/domain/entities/commission.dart';
import 'package:payinall/domain/repositories/commissions_repository.dart';

final class CommissionsRepositoryImpl implements CommissionsRepository {
  CommissionsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final CommissionsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<Commission>>> getActiveList() async {
    return _dataSourceHandler.handle<List<Commission>, List<CommissionModel>>(
      remoteFunction: () async {
        final result = await remoteDataSource.getActiveList();
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, List<Commission>>> getMerchantCommissions() async {
    return _dataSourceHandler.handle<List<Commission>, List<CommissionModel>>(
      remoteFunction: () async {
        final result = await remoteDataSource.getMerchantCommissions();
        return result;
      },
      onlyData: true,
    );
  }
}
