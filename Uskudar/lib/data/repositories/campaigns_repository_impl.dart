import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/campaigns_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/create_card_request.dart';
import 'package:uskudar_mobile/data/models/campaign_model.dart';
import 'package:uskudar_mobile/data/models/iwallet_agreement_model.dart';
import 'package:uskudar_mobile/domain/entities/campaign.dart';
import 'package:uskudar_mobile/domain/entities/iwallet_agreement.dart';
import 'package:uskudar_mobile/domain/params/create_card_params.dart';
import 'package:uskudar_mobile/domain/repositories/campaigns_repository.dart';

final class CampaignsRepositoryImpl implements CampaignsRepository {
  CampaignsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final CampaignsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<Campaign>>> getCampaigns() async {
    return _dataSourceHandler.handle<List<Campaign>, List<CampaignModel>>(
      remoteFunction: () async {
        final result = await remoteDataSource.getCampaigns();
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, String>> createQrCode() async {
    return _dataSourceHandler.handle<String, String>(
      remoteFunction: () async {
        final result = await remoteDataSource.createQrCode();
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, void>> createCard(CreateCardParams params) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final request = CreateCardRequest.fromParams(params);
        final result = await remoteDataSource.createCard(request);
        return result;
      },
    );
  }

  @override
  Future<Either<Failure, List<IWalletAgreement>>> getIWalletAgreements() async {
    return _dataSourceHandler
        .handle<List<IWalletAgreement>, List<IWalletAgreementModel>>(
          remoteFunction: () async {
            final result = await remoteDataSource.getIWalletAgreements();
            return result;
          },
          onlyData: true,
        );
  }
}
