import 'package:json_annotation/json_annotation.dart';

part 'metropol_transfer_result_response.g.dart';

@JsonSerializable(createToJson: false)
final class MetropolTransferResultResponse {
  const MetropolTransferResultResponse({
    this.merchantName,
    this.cityName,
    this.districtName,
    this.requestAmount,
    this.transactionId,
    this.productName,
    this.kdv,
    this.saleRefCode,
    this.sessionExpireDate,
  });

  factory MetropolTransferResultResponse.fromJson(Map<String, dynamic> json) =>
      _$MetropolTransferResultResponseFromJson(json);

  @JsonKey(name: 'MerchantName')
  final String? merchantName;
  @JsonKey(name: 'CityName')
  final String? cityName;
  @JsonKey(name: 'DistrictName')
  final String? districtName;
  @JsonKey(name: 'RequestAmount')
  final String? requestAmount;
  @JsonKey(name: 'TransactionId')
  final int? transactionId;
  @JsonKey(name: 'ProductName')
  final String? productName;
  @JsonKey(name: 'Kdv')
  final String? kdv;
  @JsonKey(name: 'SaleRefCode')
  final String? saleRefCode;
  @JsonKey(name: 'SessionExpireDate')
  final String? sessionExpireDate;
}
