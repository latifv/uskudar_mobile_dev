import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/domain/entities/customer_bank.dart';
import 'package:payinall/domain/params/customer_banks_params.dart';
import 'package:payinall/domain/usecases/customer_bank_usecase.dart';
import 'package:payinall/domain/usecases/customer_merchant_bank_usecase.dart';

part 'add_bank_account_event.dart';
part 'add_bank_account_state.dart';

final class AddBankAccountBloc
    extends Bloc<AddBankAccountEvent, AddBankAccountState> {
  AddBankAccountBloc({
    required CustomerBankUsecase customerBankUsecase,
    required CustomerMerchantBankUsecase customerMerchantBankUsecase,
    required UserInfoManager userInfoManager,
  }) : _customerBankUsecase = customerBankUsecase,
       _customerMerchantBankUsecase = customerMerchantBankUsecase,
       _userInfoManager = userInfoManager,
       super(const AddBankAccountState()) {
    on<AddBankAccountSave>(_onSave);
  }

  final CustomerBankUsecase _customerBankUsecase;
  final CustomerMerchantBankUsecase _customerMerchantBankUsecase;
  final UserInfoManager _userInfoManager;

  Future<void> _onSave(
    AddBankAccountSave event,
    Emitter<AddBankAccountState> emit,
  ) async {
    if (state.state == AddBankAccountBlocState.processing) {
      return;
    }

    emit(const AddBankAccountState(state: AddBankAccountBlocState.processing));

    final params = CustomerBanksParams(
      title: event.title,
      ibanNumber: event.iban,
    );

    final result = _userInfoManager.isMerchant
        ? await _customerMerchantBankUsecase(params)
        : await _customerBankUsecase(params);

    result.fold(
      (l) => emit(
        AddBankAccountState(
          state: AddBankAccountBlocState.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        const AddBankAccountState(state: AddBankAccountBlocState.success),
      ),
    );
  }
}
