import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/face_image_check_params.dart';
import 'package:payinall/domain/repositories/ark_signers_repository.dart';

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
