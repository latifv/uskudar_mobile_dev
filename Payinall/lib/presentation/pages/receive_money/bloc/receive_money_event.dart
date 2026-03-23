sealed class ReceiveMoneyEvent {
  const ReceiveMoneyEvent();
}

final class ReceiveMoneySubmitted extends ReceiveMoneyEvent {
  const ReceiveMoneySubmitted({required this.referenceNumber});

  final String referenceNumber;
}
