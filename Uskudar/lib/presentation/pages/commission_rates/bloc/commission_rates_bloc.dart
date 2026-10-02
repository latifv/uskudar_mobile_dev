import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/domain/entities/commission.dart';
import 'package:uskudar_mobile/domain/usecases/get_commissions_active_list_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_merchant_commissions_usecase.dart';

part 'commission_rates_event.dart';
part 'commission_rates_state.dart';

final class CommissionRatesBloc
    extends Bloc<CommissionRatesEvent, CommissionRatesState> {
  CommissionRatesBloc({
    required GetCommissionsActiveListUsecase getCommissionsActiveListUsecase,
    required GetMerchantCommissionsUsecase getMerchantCommissionsUsecase,
    required UserInfoManager userInfoManager,
  }) : _getCommissionsActiveListUsecase = getCommissionsActiveListUsecase,
       _getMerchantCommissionsUsecase = getMerchantCommissionsUsecase,
       _userInfoManager = userInfoManager,
       super(const CommissionRatesState()) {
    on<CommissionRatesLoadData>(_loadData);
    on<CommissionRatesTogglePanel>(_togglePanel);
  }

  final GetCommissionsActiveListUsecase _getCommissionsActiveListUsecase;
  final GetMerchantCommissionsUsecase _getMerchantCommissionsUsecase;
  final UserInfoManager _userInfoManager;

  Future<void> _loadData(
    CommissionRatesLoadData event,
    Emitter<CommissionRatesState> emit,
  ) async {
    emit(state.copyWith(status: CommissionRatesStatus.loading));

    final result = _userInfoManager.isMerchant
        ? await _getMerchantCommissionsUsecase()
        : await _getCommissionsActiveListUsecase();

    result.fold(
      (l) => emit(
        state.copyWith(status: CommissionRatesStatus.error, message: l.message),
      ),
      (r) {
        final commissionViewModels = r
            .map(
              (commission) => CommissionViewModel(
                commission: commission,
                isExpanded: false,
              ),
            )
            .toList();

        if (commissionViewModels.isNotEmpty) {
          commissionViewModels[0] = commissionViewModels[0].copyWith(
            isExpanded: true,
          );
        }

        emit(
          state.copyWith(
            status: CommissionRatesStatus.loaded,
            commissionRates: commissionViewModels,
          ),
        );
      },
    );
  }

  void _togglePanel(
    CommissionRatesTogglePanel event,
    Emitter<CommissionRatesState> emit,
  ) {
    if (state.status == CommissionRatesStatus.loaded) {
      final updatedRates = <CommissionViewModel>[];

      for (var i = 0; i < (state.commissionRates?.length ?? 0); i++) {
        if (i == event.index) {
          updatedRates.add(
            state.commissionRates![i].copyWith(isExpanded: event.isExpanded),
          );
        } else {
          updatedRates.add(
            state.commissionRates![i].copyWith(isExpanded: false),
          );
        }
      }

      emit(state.copyWith(commissionRates: updatedRates));
    }
  }
}
