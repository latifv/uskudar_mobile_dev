part of 'customer_demand_bloc.dart';

enum CustomerDemandStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error,
}

final class CustomerDemandState extends Equatable {
  const CustomerDemandState({
    this.status = CustomerDemandStatus.initial,
    this.subjects = const [],
    this.message,
  });

  final CustomerDemandStatus status;
  final List<CustomerDemandSubject> subjects;
  final String? message;

  CustomerDemandState copyWith({
    CustomerDemandStatus? status,
    List<CustomerDemandSubject>? subjects,
    String? message,
  }) {
    return CustomerDemandState(
      status: status ?? this.status,
      subjects: subjects ?? this.subjects,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, subjects, message];
}
