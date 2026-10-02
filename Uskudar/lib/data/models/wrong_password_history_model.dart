import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/wrong_password_history_response.dart';
import 'package:payinall/domain/entities/wrong_password_history.dart';

final class WrongPasswordHistoryModel extends WrongPasswordHistory {
  const WrongPasswordHistoryModel({
    required super.createdDate,
    required super.ipAddress,
  });

  factory WrongPasswordHistoryModel.fromResponse(
    WrongPasswordHistoryResponse response,
  ) {
    if (response.createdDate == null || response.ipAddress == null) {
      throw const MappingException();
    }

    return WrongPasswordHistoryModel(
      createdDate: response.createdDate!,
      ipAddress: response.ipAddress!,
    );
  }
}
