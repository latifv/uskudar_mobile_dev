part of 'commission_rates_bloc.dart';

enum CommissionRatesStatus { initial, loading, loaded, error }

final class CommissionViewModel extends Equatable {
  const CommissionViewModel({
    required this.commission,
    required this.isExpanded,
  });

  final Commission commission;
  final bool isExpanded;

  CommissionViewModel copyWith({Commission? commission, bool? isExpanded}) {
    return CommissionViewModel(
      commission: commission ?? this.commission,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  List<Object?> get props => [commission, isExpanded];
}

final class CommissionRatesState extends Equatable {
  const CommissionRatesState({
    this.status = CommissionRatesStatus.initial,
    this.commissionRates,
    this.message,
    this.key,
  });

  final CommissionRatesStatus status;
  final List<CommissionViewModel>? commissionRates;
  final String? message;
  final Key? key;

  CommissionRatesState copyWith({
    CommissionRatesStatus? status,
    List<CommissionViewModel>? commissionRates,
    String? message,
    Key? key,
  }) {
    return CommissionRatesState(
      status: status ?? this.status,
      commissionRates: commissionRates ?? this.commissionRates,
      message: message,
      key: key ?? this.key,
    );
  }

  @override
  List<Object?> get props => [status, commissionRates, message, key];
}
