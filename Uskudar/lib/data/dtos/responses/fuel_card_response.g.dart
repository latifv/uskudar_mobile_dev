// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_card_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FuelCardResponse _$FuelCardResponseFromJson(Map<String, dynamic> json) =>
    FuelCardResponse(
      id: (json['id'] as num?)?.toInt(),
      cardNo: json['cardNo'] as String?,
      isActive: json['isActive'] as bool?,
      cardType: (json['cardType'] as num?)?.toInt(),
      cardTypeName: json['cardTypeName'] as String?,
      createdDate: json['createdDate'] as String?,
    );
