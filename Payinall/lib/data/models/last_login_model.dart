import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/last_login_response.dart';
import 'package:payinall/domain/entities/last_login.dart';

final class LastLoginModel extends LastLogin {
  const LastLoginModel({required super.ipAddress, required super.date});

  factory LastLoginModel.fromResponse(LastLoginResponse response) {
    if (response.ipAddress == null || response.date == null) {
      throw const MappingException();
    }

    return LastLoginModel(ipAddress: response.ipAddress!, date: response.date!);
  }
}
