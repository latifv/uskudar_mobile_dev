import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/last_login_response.dart';
import 'package:uskudar_mobile/domain/entities/last_login.dart';

final class LastLoginModel extends LastLogin {
  const LastLoginModel({required super.ipAddress, required super.date});

  factory LastLoginModel.fromResponse(LastLoginResponse response) {
    if (response.ipAddress == null || response.date == null) {
      throw const MappingException();
    }

    return LastLoginModel(ipAddress: response.ipAddress!, date: response.date!);
  }
}
