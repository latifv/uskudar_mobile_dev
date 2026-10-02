import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/request_money_response.dart';
import 'package:payinall/domain/entities/request_money.dart';

final class RequestMoneyModel extends RequestMoney {
  const RequestMoneyModel({
    required super.id,
    required super.fromAddress,
    required super.toAddress,
    required super.toUserName,
    required super.fromUserName,
    required super.amount,
    required super.description,
    required super.createdDate,
  });

  factory RequestMoneyModel.fromResponse(RequestMoneyResponse response) {
    if (response.id == null ||
        response.fromAddress == null ||
        response.toAddress == null ||
        response.toUserName == null ||
        response.fromUserName == null ||
        response.amount == null ||
        response.description == null ||
        response.createdDate == null) {
      throw const MappingException();
    }

    return RequestMoneyModel(
      id: response.id!,
      fromAddress: response.fromAddress!,
      toAddress: response.toAddress!,
      toUserName: response.toUserName!,
      fromUserName: response.fromUserName!,
      amount: response.amount!,
      description: response.description!,
      createdDate: response.createdDate!,
    );
  }
}
