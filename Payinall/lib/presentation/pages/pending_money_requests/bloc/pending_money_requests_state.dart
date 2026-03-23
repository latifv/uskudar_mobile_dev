part of 'pending_money_requests_bloc.dart';

sealed class PendingMoneyRequestsState extends Equatable {
  const PendingMoneyRequestsState();

  @override
  List<Object?> get props => [];
}

final class PendingMoneyRequestsInitial extends PendingMoneyRequestsState {
  const PendingMoneyRequestsInitial();
}

final class PendingMoneyRequestsLoading extends PendingMoneyRequestsState {
  const PendingMoneyRequestsLoading();
}

final class PendingMoneyRequestsLoaded extends PendingMoneyRequestsState {
  const PendingMoneyRequestsLoaded({
    required this.incomingRequests,
    required this.outgoingRequests,
    required this.activeTab,
  });

  final List<RequestMoney> incomingRequests;
  final List<RequestMoney> outgoingRequests;
  final int activeTab;

  List<RequestMoney> get activeRequests =>
      activeTab == 0 ? incomingRequests : outgoingRequests;

  @override
  List<Object?> get props => [incomingRequests, outgoingRequests, activeTab];
}

final class PendingMoneyRequestsActionSuccess
    extends PendingMoneyRequestsState {
  const PendingMoneyRequestsActionSuccess({
    required this.message,
    required this.navigateToTransfer,
    required this.request,
    this.walletTransfer,
  });

  final String message;
  final bool navigateToTransfer;
  final RequestMoney request;
  final WalletTransfer? walletTransfer;

  @override
  List<Object?> get props => [
    message,
    navigateToTransfer,
    request,
    walletTransfer,
  ];
}

final class PendingMoneyRequestsError extends PendingMoneyRequestsState {
  const PendingMoneyRequestsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
