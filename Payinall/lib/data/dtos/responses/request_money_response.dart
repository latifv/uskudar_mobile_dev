import 'package:json_annotation/json_annotation.dart';

part 'request_money_response.g.dart';

@JsonSerializable(createToJson: false)
final class RequestMoneyResponse {
  const RequestMoneyResponse({
    this.id,
    this.fromAddress,
    this.toAddress,
    this.toUserName,
    this.fromUserName,
    this.amount,
    this.description,
    this.createdDate,
  });

  factory RequestMoneyResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestMoneyResponseFromJson(json);

  final int? id;
  final String? fromAddress;
  final String? toAddress;
  final String? toUserName;
  final String? fromUserName;
  final double? amount;
  final String? description;
  final DateTime? createdDate;
}
