part of 'request_money_bloc.dart';

sealed class RequestMoneyEvent {
  const RequestMoneyEvent();
}

final class RequestMoneyInitialize extends RequestMoneyEvent {
  const RequestMoneyInitialize();
}

final class RequestMoneyToggleMethod extends RequestMoneyEvent {
  const RequestMoneyToggleMethod({required this.isPhoneMethod});
  final bool isPhoneMethod;
}

final class RequestMoneySend extends RequestMoneyEvent {
  const RequestMoneySend({
    required this.amount,
    this.description,
    this.phoneNumber,
    this.walletAddress,
  });
  final String amount;
  final String? description;
  final String? phoneNumber;
  final String? walletAddress;
}
