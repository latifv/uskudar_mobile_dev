import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/contract_remote_data_source.dart';
import 'package:uskudar_mobile/data/models/contract_model.dart';
import 'package:uskudar_mobile/domain/entities/contract.dart';
import 'package:uskudar_mobile/domain/repositories/contracts_repository.dart';

final class ContractsRepositoryImpl implements ContractsRepository {
  ContractsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final ContractsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<Contract>>> getContracts() async {
    return _dataSourceHandler.handle<List<Contract>, List<ContractModel>>(
      remoteFunction: () async {
        final result = await remoteDataSource.getContracts();
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, Contract>> getContractByContractCode(
    String contractCode,
  ) async {
    return _dataSourceHandler.handle<Contract, ContractModel>(
      remoteFunction: () async {
        final result = await remoteDataSource.getContractByContractCode(
          contractCode,
        );
        return result;
      },
      onlyData: true,
    );
  }
}
