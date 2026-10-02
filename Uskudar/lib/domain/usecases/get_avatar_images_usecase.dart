import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/avatar_image.dart';
import 'package:payinall/domain/repositories/avatar_images_repository.dart';

final class GetAvatarImagesUsecase
    implements BaseUsecase<List<AvatarImage>, void> {
  GetAvatarImagesUsecase(this.repository);

  final AvatarImagesRepository repository;

  @override
  Future<Either<Failure, List<AvatarImage>>> call([void params]) async {
    return repository.getAvatarImages();
  }
}
