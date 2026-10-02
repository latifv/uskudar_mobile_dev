import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/domain/entities/wallet_transfer.dart';
import 'package:payinall/domain/entities/withdraw_transfer.dart';
import 'package:payinall/domain/enums/transfer_method.dart';
import 'package:payinall/domain/params/merchant_transfer_params.dart';
import 'package:payinall/domain/params/merchant_withdraw_transfer_params.dart';
import 'package:payinall/domain/params/wallet_transfer_params.dart';
import 'package:payinall/domain/params/withdraw_transfer_params.dart';
import 'package:payinall/domain/usecases/merchant_transfer_usecase.dart';
import 'package:payinall/domain/usecases/wallet_transfer_usecase.dart';
import 'package:payinall/domain/usecases/withdraw_merchant_transfer_usecase.dart';
import 'package:payinall/domain/usecases/withdraw_transfer_usecase.dart';

part 'transfer_amount_event.dart';
part 'transfer_amount_state.dart';

enum TransferAmountStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error,
}

final class TransferAmountBloc
    extends Bloc<TransferAmountEvent, TransferAmountState> {
  TransferAmountBloc({
    required MerchantTransferUsecase merchantTransferUsecase,
    required WalletTransferUsecase walletTransferUsecase,
    required WithdrawTransferUsecase withdrawTransferUsecase,
    required WithdrawMerchantTransferUsecase withdrawMerchantTransferUsecase,
    required UserInfoManager userInfoManager,
  }) : _merchantTransferUsecase = merchantTransferUsecase,
       _walletTransferUsecase = walletTransferUsecase,
       _withdrawTransferUsecase = withdrawTransferUsecase,
       _withdrawMerchantTransferUsecase = withdrawMerchantTransferUsecase,
       _userInfoManager = userInfoManager,
       super(const TransferAmountState()) {
    on<TransferAmountSubmitted>(_onTransferAmountSubmitted);
  }

  final MerchantTransferUsecase _merchantTransferUsecase;
  final WalletTransferUsecase _walletTransferUsecase;
  final WithdrawTransferUsecase _withdrawTransferUsecase;
  final WithdrawMerchantTransferUsecase _withdrawMerchantTransferUsecase;
  final UserInfoManager _userInfoManager;

  Future<void> _onTransferAmountSubmitted(
    TransferAmountSubmitted event,
    Emitter<TransferAmountState> emit,
  ) async {
    emit(state.copyWith(status: TransferAmountStatus.submitting));

    if (event.transferMethod == TransferMethod.wallet ||
        event.transferMethod == TransferMethod.phone) {
      final userQuery = (event.walletAddress ?? event.phone)!;
      final trimmedUserQuery = userQuery.trim();

      final result = trimmedUserQuery.startsWith('6')
          ? await _merchantTransferUsecase(
              MerchantTransferParams(
                customerNumber: trimmedUserQuery,
                amount: event.amount,
              ),
            )
          : await _walletTransferUsecase(
              WalletTransferParams(
                userQuery: trimmedUserQuery,
                amount: event.amount,
              ),
            );

      result.fold(
        (l) => emit(
          state.copyWith(
            key: UniqueKey(),
            status: TransferAmountStatus.error,
            message: l.message,
          ),
        ),
        (r) => emit(
          state.copyWith(
            status: TransferAmountStatus.success,
            walletTransfer: r,
          ),
        ),
      );
    } else if (event.transferMethod == TransferMethod.bankAccount) {
      if (_userInfoManager.isMerchant) {
        final params = MerchantWithdrawTransferParams(
          ibanNumber: event.iban!,
          amount: event.amount,
          firstName: _userInfoManager.firstName ?? '',
          lastName: _userInfoManager.lastName ?? '',
          description: event.description ?? '',
        );
        final result = await _withdrawMerchantTransferUsecase(params);

        result.fold(
          (l) => emit(
            state.copyWith(
              key: UniqueKey(),
              status: TransferAmountStatus.error,
              message: l.message,
            ),
          ),
          (r) => emit(
            state.copyWith(
              status: TransferAmountStatus.success,
              withdrawTransfer: r,
            ),
          ),
        );
      } else {
        final params = WithdrawTransferParams(
          ibanNumber: event.iban!,
          amount: event.amount,
        );

        final result = await _withdrawTransferUsecase(params);

        result.fold(
          (l) => emit(
            state.copyWith(
              key: UniqueKey(),
              status: TransferAmountStatus.error,
              message: l.message,
            ),
          ),
          (r) => emit(
            state.copyWith(
              status: TransferAmountStatus.success,
              withdrawTransfer: r,
            ),
          ),
        );
      }
    }
  }
}
