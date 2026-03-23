import 'package:json_annotation/json_annotation.dart';

part 'app_bank_response.g.dart';

@JsonSerializable(createToJson: false)
final class AppBankResponse {
  const AppBankResponse({
    this.id,
    this.bankId,
    this.bankName,
    this.iban,
    this.order,
    this.imageUrl,
    this.isActive,
  });

  factory AppBankResponse.fromJson(Map<String, dynamic> json) =>
      _$AppBankResponseFromJson(json);

  final int? id;
  final int? bankId;
  final String? bankName;
  final String? iban;
  final int? order;
  final String? imageUrl;
  final bool? isActive;
}
