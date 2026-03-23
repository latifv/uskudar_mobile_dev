part of 'request_money_bloc.dart';

enum RequestMoneyStatus { initial, loading, ready, error, success }

final class RequestMoneyState extends Equatable {
  const RequestMoneyState({
    this.status = RequestMoneyStatus.initial,
    this.isPhoneMethod = true,
    this.amountError,
    this.phoneError,
    this.walletError,
    this.requestAmount,
    this.requestRecipient,
    this.message,
    this.key,
  });

  final RequestMoneyStatus status;
  final bool isPhoneMethod;
  final String? amountError;
  final String? phoneError;
  final String? walletError;
  final String? requestAmount;
  final String? requestRecipient;
  final String? message;
  final Key? key;

  RequestMoneyState copyWith({
    RequestMoneyStatus? status,
    bool? isPhoneMethod,
    String? amountError,
    String? phoneError,
    String? walletError,
    String? requestAmount,
    String? requestRecipient,
    String? message,
    Key? key,
    bool clearAmountError = false,
    bool clearPhoneError = false,
    bool clearWalletError = false,
  }) {
    return RequestMoneyState(
      status: status ?? this.status,
      isPhoneMethod: isPhoneMethod ?? this.isPhoneMethod,
      amountError: clearAmountError ? null : amountError ?? this.amountError,
      phoneError: clearPhoneError ? null : phoneError ?? this.phoneError,
      walletError: clearWalletError ? null : walletError ?? this.walletError,
      requestAmount: requestAmount ?? this.requestAmount,
      requestRecipient: requestRecipient ?? this.requestRecipient,
      message: message,
      key: key ?? this.key,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isPhoneMethod,
    amountError,
    phoneError,
    walletError,
    requestAmount,
    requestRecipient,
    message,
    key,
  ];
}
