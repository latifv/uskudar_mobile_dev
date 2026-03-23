// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_coupon_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerCouponResponse _$CustomerCouponResponseFromJson(
  Map<String, dynamic> json,
) => CustomerCouponResponse(
  id: (json['id'] as num?)?.toInt(),
  fullName: json['fullName'] as String?,
  customerNumber: json['customerNumber'] as String?,
  customerId: (json['customerId'] as num?)?.toInt(),
  code: json['code'] as String?,
  pin: json['pin'] as String?,
  merchantName: json['merchantName'] as String?,
  logo: json['logo'] as String?,
  purchaseDate: json['purchaseDate'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  cashbackAmount: (json['cashbackAmount'] as num?)?.toDouble(),
  isDeleted: json['isDeleted'] as bool?,
);
