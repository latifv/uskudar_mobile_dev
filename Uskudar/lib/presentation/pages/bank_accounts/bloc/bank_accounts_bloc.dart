import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/customer_bank.dart';
import 'package:uskudar_mobile/domain/usecases/delete_customer_bank_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_customer_banks_usecase.dart';

part 'bank_accounts_event.dart';
part 'bank_accounts_state.dart';

final class BankAccountsBloc
    extends Bloc<BankAccountsEvent, BankAccountsState> {
  BankAccountsBloc({
    required this.getCustomerBanksUsecase,
    required this.deleteCustomerBankUsecase,
  }) : super(BankAccountsInitial()) {
    on<BankAccountsLoad>(_onBankAccountsLoad);
    on<BankAccountsDelete>(_onBankAccountsDelete);
  }

  final GetCustomerBanksUsecase getCustomerBanksUsecase;
  final DeleteCustomerBankUsecase deleteCustomerBankUsecase;

  Future<void> _onBankAccountsLoad(
    BankAccountsLoad event,
    Emitter<BankAccountsState> emit,
  ) async {
    emit(BankAccountsLoading());

    final result = await getCustomerBanksUsecase();

    result.fold(
      (failure) => emit(BankAccountsError(message: failure.message)),
      (accounts) => emit(BankAccountsLoaded(accounts: accounts)),
    );
  }

  Future<void> _onBankAccountsDelete(
    BankAccountsDelete event,
    Emitter<BankAccountsState> emit,
  ) async {
    emit(BankAccountsLoading());

    final result = await deleteCustomerBankUsecase(event.ibanNumber);

    result.fold(
      (failure) => emit(BankAccountsError(message: failure.message)),
      (_) => add(
        const BankAccountsLoad(),
      ), // Başarılı silme işleminden sonra yeniden yükle
    );
  }
}
