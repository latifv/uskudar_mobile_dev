import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/constants_data_list_remote_data_source.dart';
import 'package:uskudar_mobile/data/models/constants_data_model.dart';
import 'package:uskudar_mobile/domain/entities/constants_data.dart';
import 'package:uskudar_mobile/domain/repositories/constants_data_list_repository.dart';

final class ConstantsDataListRepositoryImpl
    implements ConstantsDataListRepository {
  ConstantsDataListRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final ConstantsDataListRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<ConstantsData>>> getAverageRevenueTypes() async {
    return _dataSourceHandler
        .handle<List<ConstantsData>, List<ConstantsDataModel>>(
          remoteFunction: () async {
            final result = await remoteDataSource.getAverageRevenueTypes();
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, List<ConstantsData>>>
  getMonthlyTransactionCountTypes() async {
    return _dataSourceHandler
        .handle<List<ConstantsData>, List<ConstantsDataModel>>(
          remoteFunction: () async {
            final result = await remoteDataSource
                .getMonthlyTransactionCountTypes();
            return result;
          },
          onlyData: true,
        );
  }
}
