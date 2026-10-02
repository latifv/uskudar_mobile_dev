import 'package:json_annotation/json_annotation.dart';

part 'customer_coupon_response.g.dart';

@JsonSerializable(createToJson: false)
final class CustomerCouponResponse {
  const CustomerCouponResponse({
    this.id,
    this.fullName,
    this.customerNumber,
    this.customerId,
    this.code,
    this.pin,
    this.merchantName,
    this.logo,
    this.purchaseDate,
    this.amount,
    this.cashbackAmount,
    this.isDeleted,
  });

  factory CustomerCouponResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerCouponResponseFromJson(json);

  final int? id;
  final String? fullName;
  final String? customerNumber;
  final int? customerId;
  final String? code;
  final String? pin;
  final String? merchantName;
  final String? logo;
  final String? purchaseDate;
  final double? amount;
  final double? cashbackAmount;
  final bool? isDeleted;
}
