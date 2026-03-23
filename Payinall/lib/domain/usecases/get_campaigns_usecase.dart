import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/campaign.dart';
import 'package:payinall/domain/repositories/campaigns_repository.dart';

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
