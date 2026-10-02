import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/campaign.dart';
import 'package:uskudar_mobile/domain/entities/iwallet_agreement.dart';
import 'package:uskudar_mobile/domain/params/create_card_params.dart';

abstract interface class CampaignsRepository {
  Future<Either<Failure, List<Campaign>>> getCampaigns();
  Future<Either<Failure, String>> createQrCode();
  Future<Either<Failure, void>> createCard(CreateCardParams params);
  Future<Either<Failure, List<IWalletAgreement>>> getIWalletAgreements();
}
