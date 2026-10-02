import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/repositories/campaigns_repository.dart';

final class CreateQrCodeUsecase implements BaseUsecaseWithoutParams<String> {
  CreateQrCodeUsecase(this.repository);

  final CampaignsRepository repository;

  @override
  Future<Either<Failure, String>> call() async {
    final result = await repository.createQrCode();
    return result;
  }
}
