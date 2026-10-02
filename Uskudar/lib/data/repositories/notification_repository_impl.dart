import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/local/notification_local_data_source.dart';
import 'package:uskudar_mobile/data/models/notification_item_model.dart';
import 'package:uskudar_mobile/domain/entities/notification_item.dart';
import 'package:uskudar_mobile/domain/repositories/notification_repository.dart';

final class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required this.localDataSource,
  }) : _dataSourceHandler = DataSourceHandler();

  final NotificationLocalDataSource localDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<NotificationItem>>> getNotifications() async {
    return _dataSourceHandler.handle<List<NotificationItem>, void>(
      localFunction: () async {
        final result = await localDataSource.getNotifications();
        return result;
      },
    );
  }

  @override
  Future<Either<Failure, void>> saveNotification(
    NotificationItem notification,
  ) async {
    return _dataSourceHandler.handle<void, void>(
      localFunction: () async {
        await localDataSource.saveNotification(
          NotificationItemModel.fromEntity(notification),
        );
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteNotification(
    String notificationId,
  ) async {
    return _dataSourceHandler.handle<void, void>(
      localFunction: () async {
        await localDataSource.deleteNotification(notificationId);
      },
    );
  }

  @override
  Future<Either<Failure, void>> clearAllNotifications() async {
    return _dataSourceHandler.handle<void, void>(
      localFunction: () async {
        await localDataSource.clearAllNotifications();
      },
    );
  }
}
