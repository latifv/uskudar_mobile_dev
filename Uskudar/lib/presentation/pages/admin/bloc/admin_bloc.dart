import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/admin_commission_summary.dart';
import 'package:payinall/domain/entities/admin_deposit_transfer_summary.dart';
import 'package:payinall/domain/entities/admin_merchant_count_summary.dart';
import 'package:payinall/domain/entities/admin_user_count_summary.dart';
import 'package:payinall/domain/entities/admin_wallet_transfer_summary.dart';
import 'package:payinall/domain/entities/admin_withdraw_transfer_summary.dart';
import 'package:payinall/domain/enums/time_type.dart';
import 'package:payinall/domain/params/admin_commission_summary_params.dart';
import 'package:payinall/domain/params/admin_deposit_transfer_summary_params.dart';
import 'package:payinall/domain/params/admin_merchant_count_params.dart';
import 'package:payinall/domain/params/admin_user_count_params.dart';
import 'package:payinall/domain/params/admin_wallet_transfer_summary_params.dart';
import 'package:payinall/domain/params/admin_withdraw_transfer_summary_params.dart';
import 'package:payinall/domain/usecases/get_admin_commission_summary_usecase.dart';
import 'package:payinall/domain/usecases/get_admin_deposit_transfer_summary_usecase.dart';
import 'package:payinall/domain/usecases/get_admin_merchant_count_usecase.dart';
import 'package:payinall/domain/usecases/get_admin_user_count_usecase.dart';
import 'package:payinall/domain/usecases/get_admin_wallet_transfer_summary_usecase.dart';
import 'package:payinall/domain/usecases/get_admin_withdraw_transfer_summary_usecase.dart';

part 'admin_event.dart';
part 'admin_state.dart';

final class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc({
    required GetAdminUserCountUsecase getAdminUserCountUsecase,
    required GetAdminMerchantCountUsecase getAdminMerchantCountUsecase,
    required GetAdminCommissionSummaryUsecase getAdminCommissionSummaryUsecase,
    required GetAdminWalletTransferSummaryUsecase
    getAdminWalletTransferSummaryUsecase,
    required GetAdminDepositTransferSummaryUsecase
    getAdminDepositTransferSummaryUsecase,
    required GetAdminWithdrawTransferSummaryUsecase
    getAdminWithdrawTransferSummaryUsecase,
  }) : _getAdminUserCountUsecase = getAdminUserCountUsecase,
       _getAdminMerchantCountUsecase = getAdminMerchantCountUsecase,
       _getAdminCommissionSummaryUsecase = getAdminCommissionSummaryUsecase,
       _getAdminWalletTransferSummaryUsecase =
           getAdminWalletTransferSummaryUsecase,
       _getAdminDepositTransferSummaryUsecase =
           getAdminDepositTransferSummaryUsecase,
       _getAdminWithdrawTransferSummaryUsecase =
           getAdminWithdrawTransferSummaryUsecase,
       super(const AdminState()) {
    on<AdminLoadData>(_onLoadData);
    on<AdminRefreshUserCount>(_onRefreshUserCount);
    on<AdminRefreshMerchantCount>(_onRefreshMerchantCount);
    on<AdminRefreshCommissionSummary>(_onRefreshCommissionSummary);
    on<AdminRefreshWalletTransferSummary>(_onRefreshWalletTransferSummary);
    on<AdminRefreshDepositTransferSummary>(_onRefreshDepositTransferSummary);
    on<AdminRefreshWithdrawTransferSummary>(_onRefreshWithdrawTransferSummary);
  }

  final GetAdminUserCountUsecase _getAdminUserCountUsecase;
  final GetAdminMerchantCountUsecase _getAdminMerchantCountUsecase;
  final GetAdminCommissionSummaryUsecase _getAdminCommissionSummaryUsecase;
  final GetAdminWalletTransferSummaryUsecase
  _getAdminWalletTransferSummaryUsecase;
  final GetAdminDepositTransferSummaryUsecase
  _getAdminDepositTransferSummaryUsecase;
  final GetAdminWithdrawTransferSummaryUsecase
  _getAdminWithdrawTransferSummaryUsecase;

  Future<void> _onLoadData(
    AdminLoadData event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(status: AdminStatus.loading));

    const defaultTimeType = TimeType.day;

    await Future.wait([
      _loadUserCount(defaultTimeType, emit),
      _loadMerchantCount(defaultTimeType, emit),
      _loadCommissionSummary(defaultTimeType, emit),
      _loadWalletTransferSummary(defaultTimeType, emit),
      _loadDepositTransferSummary(defaultTimeType, emit),
      _loadWithdrawTransferSummary(defaultTimeType, emit),
    ]);

    emit(state.copyWith(status: AdminStatus.loaded));
  }

  Future<void> _onRefreshUserCount(
    AdminRefreshUserCount event,
    Emitter<AdminState> emit,
  ) async {
    await _loadUserCount(event.timeType, emit);
  }

  Future<void> _onRefreshMerchantCount(
    AdminRefreshMerchantCount event,
    Emitter<AdminState> emit,
  ) async {
    await _loadMerchantCount(event.timeType, emit);
  }

  Future<void> _onRefreshCommissionSummary(
    AdminRefreshCommissionSummary event,
    Emitter<AdminState> emit,
  ) async {
    await _loadCommissionSummary(event.timeType, emit);
  }

  Future<void> _onRefreshWalletTransferSummary(
    AdminRefreshWalletTransferSummary event,
    Emitter<AdminState> emit,
  ) async {
    await _loadWalletTransferSummary(event.timeType, emit);
  }

  Future<void> _onRefreshDepositTransferSummary(
    AdminRefreshDepositTransferSummary event,
    Emitter<AdminState> emit,
  ) async {
    await _loadDepositTransferSummary(event.timeType, emit);
  }

  Future<void> _onRefreshWithdrawTransferSummary(
    AdminRefreshWithdrawTransferSummary event,
    Emitter<AdminState> emit,
  ) async {
    await _loadWithdrawTransferSummary(event.timeType, emit);
  }

  Future<void> _loadUserCount(
    TimeType timeType,
    Emitter<AdminState> emit,
  ) async {
    final result = await _getAdminUserCountUsecase(
      AdminUserCountParams(timeType: timeType),
    );

    result.fold(
      (l) =>
          emit(state.copyWith(status: AdminStatus.error, message: l.message)),
      (r) => emit(state.copyWith(userCountSummary: r)),
    );
  }

  Future<void> _loadMerchantCount(
    TimeType timeType,
    Emitter<AdminState> emit,
  ) async {
    final result = await _getAdminMerchantCountUsecase(
      AdminMerchantCountParams(timeType: timeType),
    );

    result.fold(
      (l) =>
          emit(state.copyWith(status: AdminStatus.error, message: l.message)),
      (r) => emit(state.copyWith(merchantCountSummary: r)),
    );
  }

  Future<void> _loadCommissionSummary(
    TimeType timeType,
    Emitter<AdminState> emit,
  ) async {
    final result = await _getAdminCommissionSummaryUsecase(
      AdminCommissionSummaryParams(timeType: timeType),
    );

    result.fold(
      (l) =>
          emit(state.copyWith(status: AdminStatus.error, message: l.message)),
      (r) => emit(state.copyWith(commissionSummary: r)),
    );
  }

  Future<void> _loadWalletTransferSummary(
    TimeType timeType,
    Emitter<AdminState> emit,
  ) async {
    final result = await _getAdminWalletTransferSummaryUsecase(
      AdminWalletTransferSummaryParams(timeType: timeType),
    );

    result.fold(
      (l) =>
          emit(state.copyWith(status: AdminStatus.error, message: l.message)),
      (r) => emit(state.copyWith(walletTransferSummary: r)),
    );
  }

  Future<void> _loadDepositTransferSummary(
    TimeType timeType,
    Emitter<AdminState> emit,
  ) async {
    final result = await _getAdminDepositTransferSummaryUsecase(
      AdminDepositTransferSummaryParams(timeType: timeType),
    );

    result.fold(
      (l) =>
          emit(state.copyWith(status: AdminStatus.error, message: l.message)),
      (r) => emit(state.copyWith(depositTransferSummary: r)),
    );
  }

  Future<void> _loadWithdrawTransferSummary(
    TimeType timeType,
    Emitter<AdminState> emit,
  ) async {
    final result = await _getAdminWithdrawTransferSummaryUsecase(
      AdminWithdrawTransferSummaryParams(timeType: timeType),
    );

    result.fold(
      (l) =>
          emit(state.copyWith(status: AdminStatus.error, message: l.message)),
      (r) => emit(state.copyWith(withdrawTransferSummary: r)),
    );
  }
}
