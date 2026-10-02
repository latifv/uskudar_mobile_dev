import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/campaign.dart';
import 'package:uskudar_mobile/domain/repositories/campaigns_repository.dart';

final class GetCampaignsUsecase
    implements BaseUsecaseWithoutParams<List<Campaign>> {
  GetCampaignsUsecase(this.repository);

  final CampaignsRepository repository;

  @override
  Future<Either<Failure, List<Campaign>>> call() async {
    final result = await repository.getCampaigns();
    return result;
  }
}
