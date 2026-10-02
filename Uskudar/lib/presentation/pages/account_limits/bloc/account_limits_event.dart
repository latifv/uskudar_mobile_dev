part of 'account_limits_bloc.dart';

sealed class AccountLimitsEvent {
  const AccountLimitsEvent();
}

final class AccountLimitsLoadData extends AccountLimitsEvent {
  const AccountLimitsLoadData();
}

final class AccountLimitsRefreshData extends AccountLimitsEvent {
  const AccountLimitsRefreshData();
}
