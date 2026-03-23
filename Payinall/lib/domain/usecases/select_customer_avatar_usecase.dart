import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/repositories/avatar_images_repository.dart';

final class SelectCustomerAvatarUsecase implements BaseUsecase<void, int> {
  SelectCustomerAvatarUsecase(this.repository);

  final AvatarImagesRepository repository;

  @override
  Future<Either<Failure, void>> call(int avatarId) async {
    return repository.selectCustomerAvatar(avatarId);
  }
}
