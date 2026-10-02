import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/metropols_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/metropol_draw_back_transfer_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/metropol_gift_transfer_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/metropol_transaction_list_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/metropol_transfer_complete_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/metropol_transfer_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/point_of_sale_location_filter_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/point_of_sale_location_request.dart';
import 'package:uskudar_mobile/data/models/metropol_city_model.dart';
import 'package:uskudar_mobile/data/models/metropol_transaction_model.dart';
import 'package:uskudar_mobile/data/models/metropol_transfer_result_model.dart';
import 'package:uskudar_mobile/data/models/metropol_user_balance_model.dart';
import 'package:uskudar_mobile/data/models/metropol_user_detail_model.dart';
import 'package:uskudar_mobile/data/models/point_of_sale_location_model.dart';
import 'package:uskudar_mobile/domain/entities/metropol_city.dart';
import 'package:uskudar_mobile/domain/entities/metropol_transaction.dart';
import 'package:uskudar_mobile/domain/entities/metropol_transfer_result.dart';
import 'package:uskudar_mobile/domain/entities/metropol_user_balance.dart';
import 'package:uskudar_mobile/domain/entities/metropol_user_detail.dart';
import 'package:uskudar_mobile/domain/entities/point_of_sale_location.dart';
import 'package:uskudar_mobile/domain/params/metropol_draw_back_transfer_params.dart';
import 'package:uskudar_mobile/domain/params/metropol_gift_transfer_params.dart';
import 'package:uskudar_mobile/domain/params/metropol_transaction_list_params.dart';
import 'package:uskudar_mobile/domain/params/metropol_transfer_complete_params.dart';
import 'package:uskudar_mobile/domain/params/metropol_transfer_params.dart';
import 'package:uskudar_mobile/domain/params/point_of_sale_location_filter_params.dart';
import 'package:uskudar_mobile/domain/params/point_of_sale_location_params.dart';
import 'package:uskudar_mobile/domain/repositories/metropols_repository.dart';

final class MetropolsRepositoryImpl implements MetropolsRepository {
  MetropolsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final MetropolsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<MetropolCity>>> getCities() async {
    return _dataSourceHandler
        .handle<List<MetropolCity>, List<MetropolCityModel>>(
      remoteFunction: () async {
        return remoteDataSource.getCities();
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, List<PointOfSaleLocation>>> pointOfSaleLocationList(
    PointOfSaleLocationParams params,
  ) async {
    return _dataSourceHandler
        .handle<List<PointOfSaleLocation>, List<PointOfSaleLocationModel>>(
      remoteFunction: () async {
        final request = PointOfSaleLocationRequest.fromParams(params);
        return remoteDataSource.pointOfSaleLocationList(request);
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, List<PointOfSaleLocation>>>
      pointOfSaleLocationFilterList(
    PointOfSaleLocationFilterParams params,
  ) async {
    return _dataSourceHandler
        .handle<List<PointOfSaleLocation>, List<PointOfSaleLocationModel>>(
      remoteFunction: () async {
        final request = PointOfSaleLocationFilterRequest.fromParams(params);
        return remoteDataSource.pointOfSaleLocationFilterList(request);
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, MetropolUserDetail>> createUserOrDetail() async {
    return _dataSourceHandler
        .handle<MetropolUserDetail, MetropolUserDetailModel>(
      remoteFunction: () async {
        return remoteDataSource.createUserOrDetail();
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, MetropolUserBalance>> getUserBalance() async {
    return _dataSourceHandler
        .handle<MetropolUserBalance, MetropolUserBalanceModel>(
      remoteFunction: () async {
        return remoteDataSource.getUserBalance();
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, List<MetropolTransaction>>> getTransactionList(
    MetropolTransactionListParams params,
  ) async {
    return _dataSourceHandler
        .handle<List<MetropolTransaction>, List<MetropolTransactionModel>>(
      remoteFunction: () async {
        final request = MetropolTransactionListRequest.fromParams(params);
        return remoteDataSource.getTransactionList(request);
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, MetropolTransferResult>> metropolTransfer(
    MetropolTransferParams params,
  ) async {
    return _dataSourceHandler
        .handle<MetropolTransferResult, MetropolTransferResultModel>(
      remoteFunction: () async {
        final request = MetropolTransferRequest.fromParams(params);
        return remoteDataSource.metropolTransfer(request);
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, String>> metropolTransferComplete(
    MetropolTransferCompleteParams params,
  ) async {
    return _dataSourceHandler.handle<String, bool>(
      remoteFunction: () async {
        final request = MetropolTransferCompleteRequest.fromParams(params);
        return remoteDataSource.metropolTransferComplete(request);
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, String>> metropolGiftTransfer(
    MetropolGiftTransferParams params,
  ) async {
    return _dataSourceHandler.handle<String, bool>(
      remoteFunction: () async {
        final request = MetropolGiftTransferRequest.fromParams(params);
        return remoteDataSource.metropolGiftTransfer(request);
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, String>> metropolDrawBackTransfer(
    MetropolDrawBackTransferParams params,
  ) async {
    return _dataSourceHandler.handle<String, bool>(
      remoteFunction: () async {
        final request = MetropolDrawBackTransferRequest.fromParams(params);
        return remoteDataSource.metropolDrawBackTransfer(request);
      },
      onlyMessage: true,
    );
  }
}
