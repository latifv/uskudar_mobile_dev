// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_wallet_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantWalletResponse _$MerchantWalletResponseFromJson(
  Map<String, dynamic> json,
) => MerchantWalletResponse(
  id: (json['id'] as num?)?.toInt(),
  customerNumber: json['customerNumber'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String?,
  merchantId: (json['merchantId'] as num?)?.toInt(),
  merchantCompanyName: json['merchantCompanyName'] as String?,
  balance: json['balance'] as num?,
  blockBalance: json['blockBalance'] as num?,
  availableBalance: json['availableBalance'] as num?,
  isWalletLocked: json['isWalletLocked'] as bool?,
);
