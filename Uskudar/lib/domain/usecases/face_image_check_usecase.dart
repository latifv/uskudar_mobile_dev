import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/face_image_check_params.dart';
import 'package:uskudar_mobile/domain/repositories/ark_signers_repository.dart';

final class FaceImageCheckUsecase
    implements BaseUsecase<void, FaceImageCheckParams> {
  FaceImageCheckUsecase(this.repository);

  final ArkSignersRepository repository;

  @override
  Future<Either<Failure, void>> call(FaceImageCheckParams params) async {
    final result = await repository.faceImageCheck(params);
    return result;
  }
}
