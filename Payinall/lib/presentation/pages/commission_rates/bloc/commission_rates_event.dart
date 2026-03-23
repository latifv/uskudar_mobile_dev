part of 'commission_rates_bloc.dart';

sealed class CommissionRatesEvent {
  const CommissionRatesEvent();
}

final class CommissionRatesLoadData extends CommissionRatesEvent {
  const CommissionRatesLoadData();
}

final class CommissionRatesTogglePanel extends CommissionRatesEvent {
  const CommissionRatesTogglePanel({
    required this.index,
    required this.isExpanded,
  });

  final int index;
  final bool isExpanded;
}
