// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$TransactionsRequestToJson(
  TransactionsRequest instance,
) => <String, dynamic>{
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'transferOperationType': instance.transferOperationType,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
};
