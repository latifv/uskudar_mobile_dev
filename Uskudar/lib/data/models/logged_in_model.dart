import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:uskudar_mobile/domain/entities/logged_in.dart';

part 'logged_in_model.g.dart';

@HiveType(typeId: 2)
final class LoggedInModel extends LoggedIn {
  const LoggedInModel({
    required super.identifier,
  });

  factory LoggedInModel.fromEntity(LoggedIn entity) {
    return LoggedInModel(
      identifier: entity.identifier,
    );
  }

  @HiveField(0)
  @override
  String get identifier => super.identifier;
}
