import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/enums/time_type.dart';
import 'package:uskudar_mobile/presentation/pages/admin/bloc/admin_bloc.dart';

mixin AdminMixin<T extends StatefulWidget> on State<T> {
  late final AdminBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<AdminBloc>();
    onAdminLoadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onAdminLoadData() {
    bloc.add(const AdminLoadData());
  }

  void onRefreshUserCount(TimeType timeType) {
    bloc.add(AdminRefreshUserCount(timeType));
  }

  void onRefreshMerchantCount(TimeType timeType) {
    bloc.add(AdminRefreshMerchantCount(timeType));
  }

  void onRefreshCommissionSummary(TimeType timeType) {
    bloc.add(AdminRefreshCommissionSummary(timeType));
  }

  void onRefreshWalletTransferSummary(TimeType timeType) {
    bloc.add(AdminRefreshWalletTransferSummary(timeType));
  }

  void onRefreshDepositTransferSummary(TimeType timeType) {
    bloc.add(AdminRefreshDepositTransferSummary(timeType));
  }

  void onRefreshWithdrawTransferSummary(TimeType timeType) {
    bloc.add(AdminRefreshWithdrawTransferSummary(timeType));
  }
}
