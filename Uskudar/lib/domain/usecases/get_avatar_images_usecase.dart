import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/avatar_image.dart';
import 'package:uskudar_mobile/domain/repositories/avatar_images_repository.dart';

final class GetAvatarImagesUsecase
    implements BaseUsecase<List<AvatarImage>, void> {
  GetAvatarImagesUsecase(this.repository);

  final AvatarImagesRepository repository;

  @override
  Future<Either<Failure, List<AvatarImage>>> call([void params]) async {
    return repository.getAvatarImages();
  }
}
