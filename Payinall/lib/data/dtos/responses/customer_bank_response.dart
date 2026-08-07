import 'package:json_annotation/json_annotation.dart';

part 'customer_bank_response.g.dart';

@JsonSerializable(createToJson: false)
final class CustomerBankResponse {
  const CustomerBankResponse({
    this.bankId,
    this.bankName,
    this.iban,
    this.title,
    this.isOwnerIban,
  });

  factory CustomerBankResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerBankResponseFromJson(json);

  final int? bankId;
  final String? bankName;
  final String? iban;
  final String? title;
  final bool? isOwnerIban;
}
