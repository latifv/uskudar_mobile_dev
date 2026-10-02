extension DateTimeExtension on DateTime {
  String toFormattedDate() {
    return '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.$year';
  }

  String toFormattedTime() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String toFormattedDateTime() {
    return '${toFormattedDate()} ${toFormattedTime()}';
  }
}
