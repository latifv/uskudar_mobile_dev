import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/avatar_image.dart';

abstract interface class AvatarImagesRepository {
  Future<Either<Failure, List<AvatarImage>>> getAvatarImages();
  Future<Either<Failure, void>> selectCustomerAvatar(int avatarId);
  Future<Either<Failure, void>> deleteCustomerAvatar();
}
