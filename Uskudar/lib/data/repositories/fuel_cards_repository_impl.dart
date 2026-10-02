import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/fuel_cards_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/create_fuel_card_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/fuel_card_top_up_request.dart';
import 'package:uskudar_mobile/data/models/fuel_card_model.dart';
import 'package:uskudar_mobile/domain/entities/fuel_card.dart';
import 'package:uskudar_mobile/domain/params/create_fuel_card_params.dart';
import 'package:uskudar_mobile/domain/params/fuel_card_top_up_params.dart';
import 'package:uskudar_mobile/domain/repositories/fuel_cards_repository.dart';

final class FuelCardsRepositoryImpl implements FuelCardsRepository {
  FuelCardsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final FuelCardsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, String>> createFuelCard(
    CreateFuelCardParams params,
  ) async {
    return _dataSourceHandler.handle<String, bool>(
      remoteFunction: () async {
        final request = CreateFuelCardRequest.fromParams(params);
        return remoteDataSource.createFuelCard(request);
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, List<FuelCard>>> getFuelCards() async {
    return _dataSourceHandler.handle<List<FuelCard>, List<FuelCardModel>>(
      remoteFunction: () async {
        return remoteDataSource.getFuelCards();
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, String>> deleteFuelCard(int id) async {
    return _dataSourceHandler.handle<String, bool>(
      remoteFunction: () async {
        return remoteDataSource.deleteFuelCard(id);
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, String>> fuelCardTopUp(
    FuelCardTopUpParams params,
  ) async {
    return _dataSourceHandler.handle<String, bool>(
      remoteFunction: () async {
        final request = FuelCardTopUpRequest.fromParams(params);
        return remoteDataSource.fuelCardTopUp(request);
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, double>> getFuelCardBalance(int id) async {
    return _dataSourceHandler.handle<double, double>(
      remoteFunction: () async {
        return remoteDataSource.getFuelCardBalance(id);
      },
      onlyData: true,
    );
  }
}
