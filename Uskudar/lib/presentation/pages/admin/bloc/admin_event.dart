part of 'admin_bloc.dart';

sealed class AdminEvent {
  const AdminEvent();
}

final class AdminLoadData extends AdminEvent {
  const AdminLoadData();
}

final class AdminRefreshUserCount extends AdminEvent {
  const AdminRefreshUserCount(this.timeType);

  final TimeType timeType;
}

final class AdminRefreshMerchantCount extends AdminEvent {
  const AdminRefreshMerchantCount(this.timeType);

  final TimeType timeType;
}

final class AdminRefreshCommissionSummary extends AdminEvent {
  const AdminRefreshCommissionSummary(this.timeType);

  final TimeType timeType;
}

final class AdminRefreshWalletTransferSummary extends AdminEvent {
  const AdminRefreshWalletTransferSummary(this.timeType);

  final TimeType timeType;
}

final class AdminRefreshDepositTransferSummary extends AdminEvent {
  const AdminRefreshDepositTransferSummary(this.timeType);

  final TimeType timeType;
}

final class AdminRefreshWithdrawTransferSummary extends AdminEvent {
  const AdminRefreshWithdrawTransferSummary(this.timeType);

  final TimeType timeType;
}
