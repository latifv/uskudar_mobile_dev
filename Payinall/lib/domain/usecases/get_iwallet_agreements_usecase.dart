import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/iwallet_agreement.dart';
import 'package:payinall/domain/repositories/campaigns_repository.dart';

final class GetIWalletAgreementsUsecase
    implements BaseUsecase<List<IWalletAgreement>, void> {
  GetIWalletAgreementsUsecase(this.repository);

  final CampaignsRepository repository;

  @override
  Future<Either<Failure, List<IWalletAgreement>>> call(void params) async {
    final result = await repository.getIWalletAgreements();
    return result;
  }
}
