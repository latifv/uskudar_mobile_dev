import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/campaign.dart';
import 'package:payinall/domain/entities/iwallet_agreement.dart';
import 'package:payinall/domain/params/create_card_params.dart';

abstract interface class CampaignsRepository {
  Future<Either<Failure, List<Campaign>>> getCampaigns();
  Future<Either<Failure, String>> createQrCode();
  Future<Either<Failure, void>> createCard(CreateCardParams params);
  Future<Either<Failure, List<IWalletAgreement>>> getIWalletAgreements();
}
