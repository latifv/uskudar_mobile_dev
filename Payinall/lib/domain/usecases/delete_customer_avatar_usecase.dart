import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/repositories/avatar_images_repository.dart';

final class DeleteCustomerAvatarUsecase implements BaseUsecase<void, void> {
  DeleteCustomerAvatarUsecase(this.repository);

  final AvatarImagesRepository repository;

  @override
  Future<Either<Failure, void>> call([void params]) async {
    return repository.deleteCustomerAvatar();
  }
}
