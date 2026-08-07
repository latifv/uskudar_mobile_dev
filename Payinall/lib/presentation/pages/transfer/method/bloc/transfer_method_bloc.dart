import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/domain/entities/customer_bank.dart';
import 'package:payinall/domain/entities/frequent_iban.dart';
import 'package:payinall/domain/entities/frequently_sent.dart';
import 'package:payinall/domain/enums/transfer_method.dart';
import 'package:payinall/domain/usecases/get_customer_banks_usecase.dart';
import 'package:payinall/domain/usecases/get_frequently_sents_usecase.dart';

part 'transfer_method_event.dart';
part 'transfer_method_state.dart';

final class TransferMethodBloc
    extends Bloc<TransferMethodEvent, TransferMethodState> {
  TransferMethodBloc({
    required GetCustomerBanksUsecase getCustomerBanksUsecase,
    required GetFrequentlySentsUsecase getFrequentlySentsUsecase,
    required UserInfoManager userInfoManager,
  }) : _getCustomerBanksUsecase = getCustomerBanksUsecase,
       _getFrequentlySentsUsecase = getFrequentlySentsUsecase,
       _userInfoManager = userInfoManager,
       super(const TransferMethodState()) {
    on<TransferMethodLoad>(_onTransferMethodLoad);
    on<TransferMethodChanged>(_onTransferMethodChanged);
    on<RecipientWalletEntered>(_onRecipientWalletEntered);
    on<RecipientPhoneEntered>(_onRecipientPhoneEntered);
    on<BankAccountSelected>(_onBankAccountSelected);
  }

  final GetCustomerBanksUsecase _getCustomerBanksUsecase;
  final GetFrequentlySentsUsecase _getFrequentlySentsUsecase;
  final UserInfoManager _userInfoManager;

  Future<void> _onTransferMethodLoad(
    TransferMethodLoad event,
    Emitter<TransferMethodState> emit,
  ) async {
    emit(state.copyWith(status: TransferMethodStatus.loading));

    final bankAccountsResult = await _getCustomerBanksUsecase();

    // Merchant transfers can only target the company's verified IBANs.
    var frequentIbans = <FrequentIban>[];
    var frequentlySents = <FrequentlySent>[];

    if (!_userInfoManager.isMerchant) {
      final sentsResult = await _getFrequentlySentsUsecase();
      sentsResult.fold((_) {}, (sents) => frequentlySents = sents);
    }

    bankAccountsResult.fold(
      (l) => emit(
        state.copyWith(status: TransferMethodStatus.error, message: l.message),
      ),
      (r) => emit(
        state.copyWith(
          status: TransferMethodStatus.loaded,
          bankAccounts: _userInfoManager.isMerchant
              ? r.where((account) => account.isOwnerIban).toList()
              : r,
          frequentIbans: frequentIbans,
          frequentlySents: frequentlySents,
          method: event.initialMethod ?? TransferMethod.wallet,
        ),
      ),
    );
  }

  void _onTransferMethodChanged(
    TransferMethodChanged event,
    Emitter<TransferMethodState> emit,
  ) {
    emit(
      state.copyWith(
        method: event.transferMethod,
        walletAddress: event.transferMethod == TransferMethod.wallet
            ? state.walletAddress
            : null,
        phone: event.transferMethod == TransferMethod.phone
            ? state.phone
            : null,
        selectedBankAccount: event.transferMethod == TransferMethod.bankAccount
            ? state.selectedBankAccount
            : null,
      ),
    );
  }

  void _onRecipientWalletEntered(
    RecipientWalletEntered event,
    Emitter<TransferMethodState> emit,
  ) {
    emit(state.copyWith(walletAddress: event.walletAddress));
  }

  void _onRecipientPhoneEntered(
    RecipientPhoneEntered event,
    Emitter<TransferMethodState> emit,
  ) {
    emit(state.copyWith(phone: event.phone));
  }

  void _onBankAccountSelected(
    BankAccountSelected event,
    Emitter<TransferMethodState> emit,
  ) {
    emit(state.copyWith(selectedBankAccount: event.bankAccount));
  }
}
