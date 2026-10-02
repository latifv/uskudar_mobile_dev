enum TimeType {
  day,
  month,
  year,
  previousOneDay,
  previousTwoDay,
  previousThreeDay,
  previousFourDay,
  previousFiveDay,
  previousSixDay,
  previousSevenDay,
  prevOneMonth,
  prevTwoMonth,
  prevThreeMonth,
  prevFourMonth,
  prevOneYear;

  const TimeType();

  int get value {
    switch (this) {
      case TimeType.day:
        return 1;
      case TimeType.month:
        return 2;
      case TimeType.year:
        return 3;
      case TimeType.previousOneDay:
        return 4;
      case TimeType.previousTwoDay:
        return 5;
      case TimeType.previousThreeDay:
        return 6;
      case TimeType.previousFourDay:
        return 7;
      case TimeType.previousFiveDay:
        return 8;
      case TimeType.previousSixDay:
        return 9;
      case TimeType.previousSevenDay:
        return 10;
      case TimeType.prevOneMonth:
        return 11;
      case TimeType.prevTwoMonth:
        return 12;
      case TimeType.prevThreeMonth:
        return 13;
      case TimeType.prevFourMonth:
        return 14;
      case TimeType.prevOneYear:
        return 15;
    }
  }

  String get description {
    switch (this) {
      case TimeType.day:
        return 'Günlük';
      case TimeType.month:
        return 'Aylık';
      case TimeType.year:
        return 'Yıllık';
      case TimeType.previousOneDay:
        return '1 Gün Önce';
      case TimeType.previousTwoDay:
        return '2 Gün Önce';
      case TimeType.previousThreeDay:
        return '3 Gün Önce';
      case TimeType.previousFourDay:
        return '4 Gün Önce';
      case TimeType.previousFiveDay:
        return '5 Gün Önce';
      case TimeType.previousSixDay:
        return '6 Gün Önce';
      case TimeType.previousSevenDay:
        return '7 Gün Önce';
      case TimeType.prevOneMonth:
        return '1 Ay Önce';
      case TimeType.prevTwoMonth:
        return '2 Ay Önce';
      case TimeType.prevThreeMonth:
        return '3 Ay Önce';
      case TimeType.prevFourMonth:
        return '4 Ay Önce';
      case TimeType.prevOneYear:
        return '1 Yıl Önce';
    }
  }
}

extension TimeTypeExtension on int {
  TimeType toTimeType() {
    return TimeType.values.firstWhere((type) => type.value == this);
  }
}
