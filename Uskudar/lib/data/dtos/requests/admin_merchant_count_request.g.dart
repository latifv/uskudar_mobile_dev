// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_merchant_count_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$AdminMerchantCountRequestToJson(
  AdminMerchantCountRequest instance,
) => <String, dynamic>{
  'timeType': _$TimeTypeEnumMap[instance.timeType]!,
  'timeTypes': instance.timeTypes,
};

const _$TimeTypeEnumMap = {
  TimeType.day: 'day',
  TimeType.month: 'month',
  TimeType.year: 'year',
  TimeType.previousOneDay: 'previousOneDay',
  TimeType.previousTwoDay: 'previousTwoDay',
  TimeType.previousThreeDay: 'previousThreeDay',
  TimeType.previousFourDay: 'previousFourDay',
  TimeType.previousFiveDay: 'previousFiveDay',
  TimeType.previousSixDay: 'previousSixDay',
  TimeType.previousSevenDay: 'previousSevenDay',
  TimeType.prevOneMonth: 'prevOneMonth',
  TimeType.prevTwoMonth: 'prevTwoMonth',
  TimeType.prevThreeMonth: 'prevThreeMonth',
  TimeType.prevFourMonth: 'prevFourMonth',
  TimeType.prevOneYear: 'prevOneYear',
};
