import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/customer_banks_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/customer_banks_request.dart';
import 'package:payinall/data/models/customer_bank_model.dart';
import 'package:payinall/domain/entities/customer_bank.dart';
import 'package:payinall/domain/params/customer_banks_params.dart';
import 'package:payinall/domain/repositories/customer_banks_repository.dart';

final class CustomerBanksRepositoryImpl implements CustomerBanksRepository {
  CustomerBanksRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final CustomerBanksRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<CustomerBank>>> getBanks() async {
    return _dataSourceHandler
        .handle<List<CustomerBank>, List<CustomerBankModel>>(
          remoteFunction: () async {
            final result = await remoteDataSource.getBanks();
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, void>> addBank(CustomerBanksParams params) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final request = CustomerBanksRequest.fromParams(params);
        final result = await remoteDataSource.addBank(request);
        return result;
      },
      onlyResponseType: true,
    );
  }

  @override
  Future<Either<Failure, void>> addMerchantBank(
    CustomerBanksParams params,
  ) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final request = CustomerBanksRequest.fromParams(params);
        final result = await remoteDataSource.addMerchantBank(request);
        return result;
      },
      onlyResponseType: true,
    );
  }

  @override
  Future<Either<Failure, void>> deleteBank(String ibanNumber) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.deleteBank(ibanNumber);
        return result;
      },
      onlyResponseType: true,
    );
  }
}
