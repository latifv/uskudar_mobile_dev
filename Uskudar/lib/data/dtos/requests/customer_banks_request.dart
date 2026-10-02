import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/customer_banks_params.dart';

part 'customer_banks_request.g.dart';

@JsonSerializable(createFactory: false)
final class CustomerBanksRequest extends CustomerBanksParams {
  const CustomerBanksRequest({required super.title, required super.ibanNumber});

  factory CustomerBanksRequest.fromParams(CustomerBanksParams params) {
    return CustomerBanksRequest(
      title: params.title,
      ibanNumber: params.ibanNumber,
    );
  }

  Map<String, dynamic> toJson() => _$CustomerBanksRequestToJson(this);
}
