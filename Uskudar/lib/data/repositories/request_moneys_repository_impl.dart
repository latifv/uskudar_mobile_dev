import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/requst_moneys_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/request_moneys_request.dart';
import 'package:uskudar_mobile/data/models/request_money_model.dart';
import 'package:uskudar_mobile/domain/entities/request_money.dart';
import 'package:uskudar_mobile/domain/params/request_moneys_params.dart';
import 'package:uskudar_mobile/domain/repositories/request_moneys_repository.dart';

final class RequestMoneysRepositoryImpl implements RequestMoneysRepository {
  RequestMoneysRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final RequestMoneysRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, void>> requestMoney(RequestMoneyParams params) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final request = RequestMoneyRequest.fromParams(params);
        final result = await remoteDataSource.requestMoney(request);
        return result;
      },
      onlyResponseType: true,
    );
  }

  @override
  Future<Either<Failure, void>> deleteRequestMoney(int id) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.deleteRequestMoney(id);
        return result;
      },
      onlyResponseType: true,
    );
  }

  @override
  Future<Either<Failure, List<RequestMoney>>> getSenderRequestMoneys() async {
    return _dataSourceHandler
        .handle<List<RequestMoney>, List<RequestMoneyModel>>(
          remoteFunction: () async {
            final result = await remoteDataSource.getSenderRequestMoneys();
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, List<RequestMoney>>> getBuyerRequestMoneys() async {
    return _dataSourceHandler
        .handle<List<RequestMoney>, List<RequestMoneyModel>>(
          remoteFunction: () async {
            final result = await remoteDataSource.getBuyerRequestMoneys();
            return result;
          },
          onlyData: true,
        );
  }
}
