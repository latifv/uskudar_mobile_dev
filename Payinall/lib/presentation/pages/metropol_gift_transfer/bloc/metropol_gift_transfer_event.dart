part of 'metropol_gift_transfer_bloc.dart';

sealed class MetropolGiftTransferEvent {
  const MetropolGiftTransferEvent();
}

final class MetropolGiftTransferSubmit extends MetropolGiftTransferEvent {
  const MetropolGiftTransferSubmit({required this.amount});

  final double amount;
}

final class MetropolGiftTransferDrawBack extends MetropolGiftTransferEvent {
  const MetropolGiftTransferDrawBack();
}
