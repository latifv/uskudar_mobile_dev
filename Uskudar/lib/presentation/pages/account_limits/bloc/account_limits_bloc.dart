import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/domain/entities/customer_process.dart';
import 'package:uskudar_mobile/domain/usecases/get_customer_process_list_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_merchant_process_list_usecase.dart';

part 'account_limits_event.dart';
part 'account_limits_state.dart';

final class AccountLimitsBloc
    extends Bloc<AccountLimitsEvent, AccountLimitsState> {
  AccountLimitsBloc({
    required GetCustomerProcessListUsecase getCustomerProcessListUsecase,
    required GetMerchantProcessListUsecase getMerchantProcessListUsecase,
    required UserInfoManager userInfoManager,
  }) : _getCustomerProcessListUsecase = getCustomerProcessListUsecase,
       _getMerchantProcessListUsecase = getMerchantProcessListUsecase,
       _userInfoManager = userInfoManager,
       super(const AccountLimitsState()) {
    on<AccountLimitsLoadData>(_loadData);
    on<AccountLimitsRefreshData>(_refreshData);
  }

  final GetCustomerProcessListUsecase _getCustomerProcessListUsecase;
  final GetMerchantProcessListUsecase _getMerchantProcessListUsecase;
  final UserInfoManager _userInfoManager;

  Future<void> _loadData(
    AccountLimitsLoadData event,
    Emitter<AccountLimitsState> emit,
  ) async {
    if (state.status == AccountLimitsStatus.loading) {
      return;
    }

    emit(state.copyWith(status: AccountLimitsStatus.loading));

    final result = _userInfoManager.isMerchant
        ? await _getMerchantProcessListUsecase()
        : await _getCustomerProcessListUsecase();

    result.fold(
      (l) => emit(
        state.copyWith(status: AccountLimitsStatus.error, message: l.message),
      ),
      (r) =>
          emit(state.copyWith(status: AccountLimitsStatus.loaded, limits: r)),
    );
  }

  Future<void> _refreshData(
    AccountLimitsRefreshData event,
    Emitter<AccountLimitsState> emit,
  ) async {
    if (state.status == AccountLimitsStatus.loading) {
      return;
    }
    emit(state.copyWith(status: AccountLimitsStatus.loading));

    final result = _userInfoManager.isMerchant
        ? await _getMerchantProcessListUsecase()
        : await _getCustomerProcessListUsecase();

    result.fold(
      (l) => emit(
        state.copyWith(
          status: AccountLimitsStatus.error,
          message: l.message,
          limits: state.limits,
        ),
      ),
      (r) =>
          emit(state.copyWith(status: AccountLimitsStatus.loaded, limits: r)),
    );
  }
}
