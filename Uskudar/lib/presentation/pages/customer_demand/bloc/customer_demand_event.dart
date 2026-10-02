part of 'customer_demand_bloc.dart';

sealed class CustomerDemandEvent {
  const CustomerDemandEvent();
}

final class CustomerDemandLoadSubjects extends CustomerDemandEvent {
  const CustomerDemandLoadSubjects();
}

final class CustomerDemandSubmit extends CustomerDemandEvent {
  const CustomerDemandSubmit({
    required this.requestSubjectId,
    required this.title,
    required this.content,
  });

  final int requestSubjectId;
  final String title;
  final String content;
}
