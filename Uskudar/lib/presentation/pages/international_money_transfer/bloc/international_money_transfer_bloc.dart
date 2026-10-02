import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/bic_bank.dart';
import 'package:uskudar_mobile/domain/entities/card_bin.dart';
import 'package:uskudar_mobile/domain/entities/corporation_attribute.dart';
import 'package:uskudar_mobile/domain/entities/international_transfer_result.dart';
import 'package:uskudar_mobile/domain/entities/office.dart';
import 'package:uskudar_mobile/domain/entities/wallet_operator.dart';
import 'package:uskudar_mobile/domain/params/cash_payout_send_transfer_params.dart';
import 'package:uskudar_mobile/domain/params/get_bic_bank_list_params.dart';
import 'package:uskudar_mobile/domain/params/get_offices_params.dart';
import 'package:uskudar_mobile/domain/params/get_required_attributes_params.dart';
import 'package:uskudar_mobile/domain/params/key_value_attribute.dart';
import 'package:uskudar_mobile/domain/usecases/cash_payout_send_transfer_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/confirm_international_transfer_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_bic_bank_list_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_card_bin_code_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_offices_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_required_attributes_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_wallet_operator_usecase.dart';

part 'international_money_transfer_event.dart';
part 'international_money_transfer_state.dart';

final class InternationalMoneyTransferBloc
    extends
        Bloc<InternationalMoneyTransferEvent, InternationalMoneyTransferState> {
  InternationalMoneyTransferBloc({
    required GetRequiredAttributesUsecase getRequiredAttributesUsecase,
    required CashPayoutSendTransferUsecase cashPayoutSendTransferUsecase,
    required ConfirmInternationalTransferUsecase
    confirmInternationalTransferUsecase,
    required GetBicBankListUsecase getBicBankListUsecase,
    required GetOfficesUsecase getOfficesUsecase,
    required GetCardBinCodeUsecase getCardBinCodeUsecase,
    required GetWalletOperatorUsecase getWalletOperatorUsecase,
  }) : _getRequiredAttributesUsecase = getRequiredAttributesUsecase,
       _cashPayoutSendTransferUsecase = cashPayoutSendTransferUsecase,
       _confirmInternationalTransferUsecase =
           confirmInternationalTransferUsecase,
       _getBicBankListUsecase = getBicBankListUsecase,
       _getOfficesUsecase = getOfficesUsecase,
       _getCardBinCodeUsecase = getCardBinCodeUsecase,
       _getWalletOperatorUsecase = getWalletOperatorUsecase,
       super(const InternationalMoneyTransferState()) {
    on<InternationalMoneyTransferLoadAttributes>(_onLoadAttributes);
    on<InternationalMoneyTransferSubmit>(_onSubmit);
    on<InternationalMoneyTransferConfirm>(_onConfirm);
    on<InternationalMoneyTransferReset>(_onReset);
    on<InternationalMoneyTransferSelectCorporation>(_onSelectCorporation);
    on<InternationalMoneyTransferLoadBicBankList>(_onLoadBicBankList);
    on<InternationalMoneyTransferLoadOffices>(_onLoadOffices);
    on<InternationalMoneyTransferLoadCardBinCode>(_onLoadCardBinCode);
    on<InternationalMoneyTransferLoadWalletOperator>(_onLoadWalletOperator);
  }

  final GetRequiredAttributesUsecase _getRequiredAttributesUsecase;
  final CashPayoutSendTransferUsecase _cashPayoutSendTransferUsecase;
  final ConfirmInternationalTransferUsecase
  _confirmInternationalTransferUsecase;
  final GetBicBankListUsecase _getBicBankListUsecase;
  final GetOfficesUsecase _getOfficesUsecase;
  final GetCardBinCodeUsecase _getCardBinCodeUsecase;
  final GetWalletOperatorUsecase _getWalletOperatorUsecase;

  Future<void> _onLoadAttributes(
    InternationalMoneyTransferLoadAttributes event,
    Emitter<InternationalMoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        status: InternationalMoneyTransferStatus.loadingAttributes,
      ),
    );

    final params = GetRequiredAttributesParams(
      countryCode: event.countryCode,
      transactionType: event.transactionType,
    );

    final result = await _getRequiredAttributesUsecase(params);

    result.fold(
      (l) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.attributesLoaded,
          corporationAttributes: r,
          selectedCorporation: r.isNotEmpty ? r.first : null,
        ),
      ),
    );
  }

  Future<void> _onSubmit(
    InternationalMoneyTransferSubmit event,
    Emitter<InternationalMoneyTransferState> emit,
  ) async {
    emit(state.copyWith(status: InternationalMoneyTransferStatus.submitting));

    final requiredAttributes = event.requiredAttributes.entries
        .map((e) => KeyValueAttribute(key: e.key, value: e.value))
        .toList();

    final params = CashPayoutSendTransferParams(
      beneficiaryCountryCode: event.beneficiaryCountryCode,
      beneficiaryName: event.beneficiaryName,
      beneficiarySurname: event.beneficiarySurname,
      beneficiaryGsmCountryCode: event.beneficiaryGsmCountryCode,
      beneficiaryGsmNo: event.beneficiaryGsmNo,
      amount: event.amount,
      moneyTakenCurrency: event.moneyTakenCurrency,
      transactionType: event.transactionType,
      transferType: event.transferType,
      requiredAttributes: requiredAttributes,
    );

    final result = await _cashPayoutSendTransferUsecase(params);

    result.fold(
      (l) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.submitted,
          transferResult: r,
        ),
      ),
    );
  }

  Future<void> _onConfirm(
    InternationalMoneyTransferConfirm event,
    Emitter<InternationalMoneyTransferState> emit,
  ) async {
    emit(state.copyWith(status: InternationalMoneyTransferStatus.confirming));

    final result = await _confirmInternationalTransferUsecase(
      event.transactionId,
    );

    result.fold(
      (l) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.confirmed,
          message: r,
        ),
      ),
    );
  }

  void _onReset(
    InternationalMoneyTransferReset event,
    Emitter<InternationalMoneyTransferState> emit,
  ) {
    emit(const InternationalMoneyTransferState());
  }

  void _onSelectCorporation(
    InternationalMoneyTransferSelectCorporation event,
    Emitter<InternationalMoneyTransferState> emit,
  ) {
    emit(
      state.copyWith(
        selectedCorporation: event.corporation,
        status: InternationalMoneyTransferStatus.attributesLoaded,
        message: null,
      ),
    );
  }

  Future<void> _onLoadBicBankList(
    InternationalMoneyTransferLoadBicBankList event,
    Emitter<InternationalMoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        status: InternationalMoneyTransferStatus.loadingTransactionTypeData,
      ),
    );

    final params = GetBicBankListParams(
      countryCode: event.countryCode,
      corporationCode: event.corporationCode,
    );

    final result = await _getBicBankListUsecase(params);

    result.fold(
      (l) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.transactionTypeDataLoaded,
          bicBankList: r,
        ),
      ),
    );
  }

  Future<void> _onLoadOffices(
    InternationalMoneyTransferLoadOffices event,
    Emitter<InternationalMoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        status: InternationalMoneyTransferStatus.loadingTransactionTypeData,
      ),
    );

    final params = GetOfficesParams(
      countryCode: event.countryCode,
      officeType: event.officeType,
      corporationCode: event.corporationCode,
    );

    final result = await _getOfficesUsecase(params);

    result.fold(
      (l) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.transactionTypeDataLoaded,
          officeList: r,
        ),
      ),
    );
  }

  Future<void> _onLoadCardBinCode(
    InternationalMoneyTransferLoadCardBinCode event,
    Emitter<InternationalMoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        status: InternationalMoneyTransferStatus.loadingTransactionTypeData,
      ),
    );

    final result = await _getCardBinCodeUsecase(event.countryCode);

    result.fold(
      (l) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.transactionTypeDataLoaded,
          cardBinList: r,
        ),
      ),
    );
  }

  Future<void> _onLoadWalletOperator(
    InternationalMoneyTransferLoadWalletOperator event,
    Emitter<InternationalMoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        status: InternationalMoneyTransferStatus.loadingTransactionTypeData,
      ),
    );

    final result = await _getWalletOperatorUsecase(event.countryCode);

    result.fold(
      (l) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: InternationalMoneyTransferStatus.transactionTypeDataLoaded,
          walletOperatorList: r,
        ),
      ),
    );
  }
}
