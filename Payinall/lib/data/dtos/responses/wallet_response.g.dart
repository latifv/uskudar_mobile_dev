// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletResponse _$WalletResponseFromJson(Map<String, dynamic> json) =>
    WalletResponse(
      balance: (json['balance'] as num?)?.toDouble(),
      availableBalance: (json['availableBalance'] as num?)?.toDouble(),
      blockBalance: (json['blockBalance'] as num?)?.toDouble(),
    );
