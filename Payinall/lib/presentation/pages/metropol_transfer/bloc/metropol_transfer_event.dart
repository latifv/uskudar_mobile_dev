part of 'metropol_transfer_bloc.dart';

sealed class MetropolTransferEvent {
  const MetropolTransferEvent();
}

final class MetropolTransferSubmit extends MetropolTransferEvent {
  const MetropolTransferSubmit({
    required this.codeTypes,
    required this.code,
  });

  final int codeTypes;
  final String code;
}

final class MetropolTransferConfirm extends MetropolTransferEvent {
  const MetropolTransferConfirm({required this.transactionId});

  final String transactionId;
}

final class MetropolTransferDrawBack extends MetropolTransferEvent {
  const MetropolTransferDrawBack();
}
