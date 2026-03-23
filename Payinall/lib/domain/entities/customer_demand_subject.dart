import 'package:equatable/equatable.dart';

class CustomerDemandSubject extends Equatable {
  const CustomerDemandSubject({required this.key, required this.value});

  final int key;
  final String value;

  @override
  List<Object?> get props => [key, value];
}
