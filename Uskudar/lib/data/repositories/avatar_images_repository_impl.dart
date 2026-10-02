import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/avatar_images_remote_data_source.dart';
import 'package:uskudar_mobile/domain/entities/avatar_image.dart';
import 'package:uskudar_mobile/domain/repositories/avatar_images_repository.dart';

final class AvatarImagesRepositoryImpl implements AvatarImagesRepository {
  AvatarImagesRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final AvatarImagesRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<AvatarImage>>> getAvatarImages() async {
    return _dataSourceHandler.handle<List<AvatarImage>, List<AvatarImage>>(
      remoteFunction: () async {
        final result = await remoteDataSource.getAvatarImages();
        return result.map((list) => list.map((e) => e.toEntity()).toList());
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, void>> selectCustomerAvatar(int avatarId) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.selectCustomerAvatar(avatarId);
        return result;
      },
      onlyResponseType: true,
    );
  }

  @override
  Future<Either<Failure, void>> deleteCustomerAvatar() async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.deleteCustomerAvatar();
        return result;
      },
      onlyResponseType: true,
    );
  }
}
