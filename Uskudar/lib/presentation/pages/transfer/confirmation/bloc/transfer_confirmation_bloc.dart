import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/domain/entities/wallet_transfer.dart';
import 'package:payinall/domain/entities/withdraw_transfer.dart';
import 'package:payinall/domain/usecases/merchant_withdraw_transfer_complete_usecase.dart';
import 'package:payinall/domain/usecases/wallet_transfer_complete_usecase.dart';
import 'package:payinall/domain/usecases/withdraw_transfer_complete_usecase.dart';

part 'transfer_confirmation_event.dart';
part 'transfer_confirmation_state.dart';

final class TransferConfirmationBloc
    extends Bloc<TransferConfirmationEvent, TransferConfirmationState> {
  TransferConfirmationBloc({
    required WalletTransferCompleteUsecase walletTransferCompleteUsecase,
    required WithdrawTransferCompleteUsecase withdrawTransferCompleteUsecase,
    required MerchantWithdrawTransferCompleteUsecase
    merchantWithdrawTransferCompleteUsecase,
    required UserInfoManager userInfoManager,
  }) : _walletTransferCompleteUsecase = walletTransferCompleteUsecase,
       _withdrawTransferCompleteUsecase = withdrawTransferCompleteUsecase,
       _merchantWithdrawTransferCompleteUsecase =
           merchantWithdrawTransferCompleteUsecase,
       _userInfoManager = userInfoManager,
       super(const TransferConfirmationState()) {
    on<TransferConfirmationSubmit>(_onTransferConfirmationSubmit);
  }

  final WalletTransferCompleteUsecase _walletTransferCompleteUsecase;
  final WithdrawTransferCompleteUsecase _withdrawTransferCompleteUsecase;
  final MerchantWithdrawTransferCompleteUsecase
  _merchantWithdrawTransferCompleteUsecase;
  final UserInfoManager _userInfoManager;

  Future<void> _onTransferConfirmationSubmit(
    TransferConfirmationSubmit event,
    Emitter<TransferConfirmationState> emit,
  ) async {
    emit(state.copyWith(status: TransferConfirmationStatus.loading));

    if (event.walletTransfer != null) {
      final result = await _walletTransferCompleteUsecase(
        event.walletTransfer!.transactionNumber,
      );

      result.fold(
        (l) => emit(
          state.copyWith(
            status: TransferConfirmationStatus.error,
            message: l.message,
          ),
        ),
        (r) => emit(
          state.copyWith(
            status: TransferConfirmationStatus.success,
            message: r,
          ),
        ),
      );
    } else if (event.withdrawTransfer != null) {
      final result = _userInfoManager.isMerchant
          ? await _merchantWithdrawTransferCompleteUsecase(
              event.withdrawTransfer!.transactionNumber,
            )
          : await _withdrawTransferCompleteUsecase(
              event.withdrawTransfer!.transactionNumber,
            );

      result.fold(
        (l) => emit(
          state.copyWith(
            status: TransferConfirmationStatus.error,
            message: l.message,
          ),
        ),
        (r) => emit(
          state.copyWith(
            status: TransferConfirmationStatus.success,
            message: r,
          ),
        ),
      );
    }
  }
}
