import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/front_image_check_params.dart';
import 'package:payinall/domain/repositories/ark_signers_repository.dart';

final class FrontImageCheckUsecase
    implements BaseUsecase<String, FrontImageCheckParams> {
  FrontImageCheckUsecase(this.repository);

  final ArkSignersRepository repository;

  @override
  Future<Either<Failure, String>> call(FrontImageCheckParams params) async {
    final result = await repository.frontImageCheck(params);
    return result;
  }
}
