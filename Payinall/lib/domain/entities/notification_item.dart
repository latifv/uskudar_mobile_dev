import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
  });
  final String id;
  final String title;
  final String message;
  final DateTime date;

  @override
  List<Object?> get props => [id, title, message, date];
}
