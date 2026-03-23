part of 'admin_bloc.dart';

enum AdminStatus { initial, loading, loaded, error }

final class AdminState extends Equatable {
  const AdminState({
    this.status = AdminStatus.initial,
    this.userCountSummary,
    this.merchantCountSummary,
    this.commissionSummary,
    this.walletTransferSummary,
    this.depositTransferSummary,
    this.withdrawTransferSummary,
    this.message,
  });

  final AdminStatus status;
  final AdminUserCountSummary? userCountSummary;
  final AdminMerchantCountSummary? merchantCountSummary;
  final AdminCommissionSummary? commissionSummary;
  final AdminWalletTransferSummary? walletTransferSummary;
  final AdminDepositTransferSummary? depositTransferSummary;
  final AdminWithdrawTransferSummary? withdrawTransferSummary;
  final String? message;

  AdminState copyWith({
    AdminStatus? status,
    AdminUserCountSummary? userCountSummary,
    AdminMerchantCountSummary? merchantCountSummary,
    AdminCommissionSummary? commissionSummary,
    AdminWalletTransferSummary? walletTransferSummary,
    AdminDepositTransferSummary? depositTransferSummary,
    AdminWithdrawTransferSummary? withdrawTransferSummary,
    String? message,
  }) {
    return AdminState(
      status: status ?? this.status,
      userCountSummary: userCountSummary ?? this.userCountSummary,
      merchantCountSummary: merchantCountSummary ?? this.merchantCountSummary,
      commissionSummary: commissionSummary ?? this.commissionSummary,
      walletTransferSummary:
          walletTransferSummary ?? this.walletTransferSummary,
      depositTransferSummary:
          depositTransferSummary ?? this.depositTransferSummary,
      withdrawTransferSummary:
          withdrawTransferSummary ?? this.withdrawTransferSummary,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userCountSummary,
    merchantCountSummary,
    commissionSummary,
    walletTransferSummary,
    depositTransferSummary,
    withdrawTransferSummary,
    message,
  ];
}
