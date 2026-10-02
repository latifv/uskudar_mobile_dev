import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/repositories/avatar_images_repository.dart';

final class DeleteCustomerAvatarUsecase implements BaseUsecase<void, void> {
  DeleteCustomerAvatarUsecase(this.repository);

  final AvatarImagesRepository repository;

  @override
  Future<Either<Failure, void>> call([void params]) async {
    return repository.deleteCustomerAvatar();
  }
}
