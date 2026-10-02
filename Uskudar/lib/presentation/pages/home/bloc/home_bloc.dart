import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/domain/entities/frequent_iban.dart';
import 'package:payinall/domain/entities/frequently_sent.dart';
import 'package:payinall/domain/entities/transaction.dart';
import 'package:payinall/domain/usecases/get_current_user_info_usecase.dart';
import 'package:payinall/domain/usecases/get_frequent_ibans_usecase.dart';
import 'package:payinall/domain/usecases/get_frequently_sents_usecase.dart';
import 'package:payinall/domain/usecases/get_last_transactions_usecase.dart';
import 'package:payinall/domain/usecases/get_merchant_last_transactions_usecase.dart';
import 'package:payinall/domain/usecases/get_merchant_wallet_usecase.dart';
import 'package:payinall/domain/usecases/get_wallet_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

final class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetCurrentUserInfoUsecase getCurrentUserInfoUsecase,
    required GetWalletUsecase getWalletUsecase,
    required GetMerchantWalletUsecase getMerchantWalletUsecase,
    required GetLastTransactionsUsecase getLastTransactionsUsecase,
    required GetMerchantLastTransactionsUsecase
    getMerchantLastTransactionsUsecase,
    required GetFrequentIbansUsecase getFrequentIbansUsecase,
    required GetFrequentlySentsUsecase getFrequentlySentsUsecase,
    required UserInfoManager userInfoManager,
  }) : _getCurrentUserInfoUsecase = getCurrentUserInfoUsecase,
       _getWalletUsecase = getWalletUsecase,
       _getMerchantWalletUsecase = getMerchantWalletUsecase,
       _getLastTransactionsUsecase = getLastTransactionsUsecase,
       _getMerchantLastTransactionsUsecase = getMerchantLastTransactionsUsecase,
       _getFrequentIbansUsecase = getFrequentIbansUsecase,
       _getFrequentlySentsUsecase = getFrequentlySentsUsecase,
       _userInfoManager = userInfoManager,
       super(const HomeState()) {
    on<HomeLoadData>(_onLoadHomeData);
    on<HomeRefreshData>(_onRefreshHomeData);
    on<HomeRefreshUserInfo>(_onRefreshUserInfo);
    on<HomeRefreshBalance>(_onRefreshBalanceHomeData);
    on<HomeRefreshTransactions>(_onRefreshTransactions);
    on<HomeUpdateAvatarImage>(_onUpdateAvatarImage);
    on<HomeDismissUserInfoCard>(_onDismissUserInfoCard);
  }

  final GetCurrentUserInfoUsecase _getCurrentUserInfoUsecase;
  final GetWalletUsecase _getWalletUsecase;
  final GetMerchantWalletUsecase _getMerchantWalletUsecase;
  final GetLastTransactionsUsecase _getLastTransactionsUsecase;
  final GetMerchantLastTransactionsUsecase _getMerchantLastTransactionsUsecase;
  final GetFrequentIbansUsecase _getFrequentIbansUsecase;
  final GetFrequentlySentsUsecase _getFrequentlySentsUsecase;
  final UserInfoManager _userInfoManager;

  Future<void> _onLoadHomeData(
    HomeLoadData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    if (_userInfoManager.isMerchant) {
      final merchantWallet = await _getMerchantWalletUsecase();
      merchantWallet.fold(
        (l) =>
            emit(state.copyWith(status: HomeStatus.error, message: l.message)),
        (r) {
          _userInfoManager.setMerchantInfo(
            customerNumber: r.customerNumber,
            firstName: r.firstName,
            lastName: r.lastName,
            email: r.email,
            merchantId: r.merchantId,
            merchantCompanyName: r.merchantCompanyName,
            balance: r.balance,
            blockBalance: r.blockBalance,
            availableBalance: r.availableBalance,
            isWalletLocked: r.isWalletLocked,
          );
          emit(
            state.copyWith(
              status: HomeStatus.loading,
              walletAddress: _userInfoManager.walletAddress,
              firstName: _userInfoManager.firstName,
              balance: _userInfoManager.merchantBalance?.toDouble(),
              blockBalance: _userInfoManager.merchantBlockBalance?.toDouble(),
            ),
          );
        },
      );

      final merchantTransactions = await _getMerchantLastTransactionsUsecase(
        10,
      );

      merchantTransactions.fold(
        (l) =>
            emit(state.copyWith(status: HomeStatus.error, message: l.message)),
        (r) {
          emit(
            state.copyWith(
              status: HomeStatus.loaded,
              transactions: _sortTransactions(r),
            ),
          );
        },
      );

      final frequentIbans = await _getFrequentIbansUsecase();
      frequentIbans.fold(
        (_) {},
        (ibans) => emit(state.copyWith(frequentIbans: ibans)),
      );
    } else {
      final currentUserInfo = await _getCurrentUserInfoUsecase();

      currentUserInfo.fold(
        (l) =>
            emit(state.copyWith(status: HomeStatus.error, message: l.message)),
        (r) {
          _userInfoManager.setUserInfo(r);
          emit(
            state.copyWith(
              status: HomeStatus.loading,
              walletAddress: _userInfoManager.walletAddress,
              firstName: _userInfoManager.firstName,
              image: _userInfoManager.image,
            ),
          );
        },
      );
      final wallet = await _getWalletUsecase();
      wallet.fold(
        (l) =>
            emit(state.copyWith(status: HomeStatus.error, message: l.message)),
        (r) => emit(
          state.copyWith(
            status: HomeStatus.loading,
            balance: r.balance,
            blockBalance: r.blockBalance,
          ),
        ),
      );

      final transactions = await _getLastTransactionsUsecase(10);

      transactions.fold(
        (l) =>
            emit(state.copyWith(status: HomeStatus.error, message: l.message)),
        (r) {
          emit(
            state.copyWith(
              status: HomeStatus.loading,
              transactions: _sortTransactions(r),
            ),
          );
        },
      );

      final frequentlySents = await _getFrequentlySentsUsecase();
      frequentlySents.fold(
        (_) {},
        (sents) => emit(state.copyWith(frequentlySents: sents)),
      );

      if (_userInfoManager.customerType == 1) {
        emit(
          state.copyWith(
            status: HomeStatus.requiredScoringQuestions,
            customerType: 1,
            addressType: _userInfoManager.addressType,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: HomeStatus.loaded,
            customerType: _userInfoManager.customerType,
            addressType: _userInfoManager.addressType,
            lastWrongPasswordDate: _userInfoManager.lastWrongPasswordDate
                ?.toIso8601String(),
            lastWrongIpAddress: _userInfoManager.lastWrongIpAddress,
          ),
        );
      }
    }
  }

  Future<void> _onRefreshHomeData(
    HomeRefreshData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(dismissedCards: []));

    add(const HomeRefreshBalance());
    add(const HomeRefreshUserInfo());
    add(const HomeRefreshTransactions());
  }

  Future<void> _onRefreshTransactions(
    HomeRefreshTransactions event,
    Emitter<HomeState> emit,
  ) async {
    if (_userInfoManager.isMerchant) {
      final transactions = await _getMerchantLastTransactionsUsecase(10);
      transactions.fold(
        (l) =>
            emit(state.copyWith(status: HomeStatus.error, message: l.message)),
        (r) => emit(
          state.copyWith(
            status: HomeStatus.loaded,
            transactions: _sortTransactions(r),
          ),
        ),
      );

      final frequentIbans = await _getFrequentIbansUsecase();
      frequentIbans.fold(
        (_) {},
        (ibans) => emit(state.copyWith(frequentIbans: ibans)),
      );
    } else {
      final transactions = await _getLastTransactionsUsecase(10);
      transactions.fold(
        (l) =>
            emit(state.copyWith(status: HomeStatus.error, message: l.message)),
        (r) => emit(
          state.copyWith(
            status: HomeStatus.loaded,
            transactions: _sortTransactions(r),
          ),
        ),
      );

      final frequentlySents = await _getFrequentlySentsUsecase();
      frequentlySents.fold(
        (_) {},
        (sents) => emit(state.copyWith(frequentlySents: sents)),
      );
    }
  }

  List<Transaction> _sortTransactions(List<Transaction> transactions) {
    return [...transactions]..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _onRefreshBalanceHomeData(
    HomeRefreshBalance event,
    Emitter<HomeState> emit,
  ) async {
    if (_userInfoManager.isMerchant) {
      final merchantWallet = await _getMerchantWalletUsecase();
      merchantWallet.fold(
        (l) =>
            emit(state.copyWith(status: HomeStatus.error, message: l.message)),
        (r) => emit(
          state.copyWith(
            status: HomeStatus.loaded,
            balance: r.balance.toDouble(),
            blockBalance: r.blockBalance.toDouble(),
          ),
        ),
      );
    } else {
      final wallet = await _getWalletUsecase();
      wallet.fold(
        (l) =>
            emit(state.copyWith(status: HomeStatus.error, message: l.message)),
        (r) => emit(
          state.copyWith(
            status: HomeStatus.loaded,
            balance: r.balance,
            blockBalance: r.blockBalance,
          ),
        ),
      );
    }
  }

  Future<void> _onRefreshUserInfo(
    HomeRefreshUserInfo event,
    Emitter<HomeState> emit,
  ) async {
    if (_userInfoManager.isMerchant) {
      emit(state.copyWith(status: HomeStatus.loading));
      final merchantWallet = await _getMerchantWalletUsecase();
      merchantWallet.fold(
        (l) =>
            emit(state.copyWith(status: HomeStatus.error, message: l.message)),
        (r) {
          _userInfoManager.setMerchantInfo(
            customerNumber: r.customerNumber,
            firstName: r.firstName,
            lastName: r.lastName,
            email: r.email,
            merchantId: r.merchantId,
            merchantCompanyName: r.merchantCompanyName,
            balance: r.balance,
            blockBalance: r.blockBalance,
            availableBalance: r.availableBalance,
            isWalletLocked: r.isWalletLocked,
          );
          emit(
            state.copyWith(
              status: HomeStatus.loaded,
              walletAddress: _userInfoManager.walletAddress,
              firstName: _userInfoManager.firstName,
              balance: _userInfoManager.merchantBalance?.toDouble(),
              blockBalance: _userInfoManager.merchantBlockBalance?.toDouble(),
              customerType: _userInfoManager.customerType,
              addressType: _userInfoManager.addressType,
            ),
          );
        },
      );
    } else {
      emit(state.copyWith(status: HomeStatus.loading));
      final currentUserInfo = await _getCurrentUserInfoUsecase();

      currentUserInfo.fold(
        (l) =>
            emit(state.copyWith(status: HomeStatus.error, message: l.message)),
        (r) {
          _userInfoManager.setUserInfo(r);
          emit(
            state.copyWith(
              status: HomeStatus.loaded,
              customerType: _userInfoManager.customerType,
              addressType: _userInfoManager.addressType,
              image: _userInfoManager.image,
            ),
          );
        },
      );
    }
  }

  void _onUpdateAvatarImage(
    HomeUpdateAvatarImage event,
    Emitter<HomeState> emit,
  ) {
    _userInfoManager.setImage(event.image);
    emit(state.copyWith(image: event.image));
  }

  void _onDismissUserInfoCard(
    HomeDismissUserInfoCard event,
    Emitter<HomeState> emit,
  ) {
    final updatedDismissedCards = List<UserInfoCardType>.from(
      state.dismissedCards,
    )..add(event.cardType);

    emit(
      state.copyWith(
        dismissedCards: updatedDismissedCards,
      ),
    );
  }
}
