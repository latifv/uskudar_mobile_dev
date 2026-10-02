import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/presentation/pages/deposit/bank_detail/bloc/bank_detail_event.dart';
import 'package:uskudar_mobile/presentation/pages/deposit/bank_detail/bloc/bank_detail_state.dart';

final class BankDetailBloc extends Bloc<BankDetailEvent, BankDetailState> {
  BankDetailBloc({required UserInfoManager userInfoManager})
    : _userInfoManager = userInfoManager,
      super(const BankDetailState()) {
    on<BankDetailFetched>(_onBankDetailFetched);
    on<BankDetailWalletAddressFetched>(_onBankDetailWalletAddressFetched);
  }

  final UserInfoManager _userInfoManager;

  Future<void> _onBankDetailFetched(
    BankDetailFetched event,
    Emitter<BankDetailState> emit,
  ) async {
    emit(state.copyWith(status: BankDetailStatus.loading));
    emit(state.copyWith(status: BankDetailStatus.loaded, bank: event.bank));
  }

  Future<void> _onBankDetailWalletAddressFetched(
    BankDetailWalletAddressFetched event,
    Emitter<BankDetailState> emit,
  ) async {
    final walletAddress = _userInfoManager.walletAddress;
    emit(state.copyWith(walletAddress: walletAddress));
  }
}
