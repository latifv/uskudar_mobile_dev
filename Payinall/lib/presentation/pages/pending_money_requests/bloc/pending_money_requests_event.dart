part of 'pending_money_requests_bloc.dart';

sealed class PendingMoneyRequestsEvent {
  const PendingMoneyRequestsEvent();
}

final class PendingMoneyRequestsLoadData extends PendingMoneyRequestsEvent {
  const PendingMoneyRequestsLoadData({this.tabIndex});

  final int? tabIndex;
}

final class PendingMoneyRequestsApprove extends PendingMoneyRequestsEvent {
  const PendingMoneyRequestsApprove({
    required this.requestId,
    required this.request,
  });

  final int requestId;
  final RequestMoney request;
}

final class PendingMoneyRequestsReject extends PendingMoneyRequestsEvent {
  const PendingMoneyRequestsReject({
    required this.requestId,
    required this.request,
  });

  final int requestId;
  final RequestMoney request;
}

final class PendingMoneyRequestsDelete extends PendingMoneyRequestsEvent {
  const PendingMoneyRequestsDelete({
    required this.requestId,
    required this.request,
  });

  final int requestId;
  final RequestMoney request;
}

final class PendingMoneyRequestsTabChanged extends PendingMoneyRequestsEvent {
  const PendingMoneyRequestsTabChanged({required this.tabIndex});

  final int tabIndex;
}
