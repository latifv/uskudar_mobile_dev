import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/back_image_check_params.dart';
import 'package:uskudar_mobile/domain/repositories/ark_signers_repository.dart';

final class BackImageCheckUsecase
    implements BaseUsecase<void, BackImageCheckParams> {
  BackImageCheckUsecase(this.repository);

  final ArkSignersRepository repository;

  @override
  Future<Either<Failure, void>> call(BackImageCheckParams params) async {
    final result = await repository.backImageCheck(params);
    return result;
  }
}
