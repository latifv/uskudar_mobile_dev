import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:payinall/domain/entities/notification_item.dart';

part 'notification_item_model.g.dart';

@HiveType(typeId: 4)
final class NotificationItemModel extends NotificationItem {
  const NotificationItemModel({
    required super.id,
    required super.title,
    required super.message,
    required super.date,
  });

  factory NotificationItemModel.fromEntity(NotificationItem entity) {
    return NotificationItemModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      date: entity.date,
    );
  }

  @HiveField(0)
  @override
  String get id => super.id;

  @HiveField(1)
  @override
  String get title => super.title;

  @HiveField(2)
  @override
  String get message => super.message;

  @HiveField(3)
  @override
  DateTime get date => super.date;
}
