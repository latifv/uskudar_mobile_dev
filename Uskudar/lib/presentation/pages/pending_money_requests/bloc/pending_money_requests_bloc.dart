import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/request_money.dart';
import 'package:uskudar_mobile/domain/entities/wallet_transfer.dart';
import 'package:uskudar_mobile/domain/params/wallet_transfer_params.dart';
import 'package:uskudar_mobile/domain/usecases/delete_request_money_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_buyer_request_moneys_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_sender_request_moneys_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/wallet_transfer_usecase.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

part 'pending_money_requests_event.dart';
part 'pending_money_requests_state.dart';

final class PendingMoneyRequestsBloc
    extends Bloc<PendingMoneyRequestsEvent, PendingMoneyRequestsState> {
  PendingMoneyRequestsBloc({
    required this.getBuyerRequestMoneysUsecase,
    required this.getSenderRequestMoneysUsecase,
    required this.deleteRequestMoneyUsecase,
    required this.walletTransferUsecase,
  }) : super(const PendingMoneyRequestsInitial()) {
    on<PendingMoneyRequestsLoadData>(_onLoadData);
    on<PendingMoneyRequestsApprove>(_onApproveRequest);
    on<PendingMoneyRequestsReject>(_onRejectRequest);
    on<PendingMoneyRequestsDelete>(_onDeleteRequest);
    on<PendingMoneyRequestsTabChanged>(_onTabChanged);
  }

  final GetBuyerRequestMoneysUsecase getBuyerRequestMoneysUsecase;
  final GetSenderRequestMoneysUsecase getSenderRequestMoneysUsecase;
  final DeleteRequestMoneyUsecase deleteRequestMoneyUsecase;
  final WalletTransferUsecase walletTransferUsecase;

  Future<void> _onLoadData(
    PendingMoneyRequestsLoadData event,
    Emitter<PendingMoneyRequestsState> emit,
  ) async {
    emit(const PendingMoneyRequestsLoading());

    final activeTab = event.tabIndex ?? 0;

    final incomingResult = await getBuyerRequestMoneysUsecase.call();
    final outgoingResult = await getSenderRequestMoneysUsecase.call();

    return incomingResult.fold(
      (failure) => emit(PendingMoneyRequestsError(message: failure.message)),
      (incomingRequests) => outgoingResult.fold(
        (failure) => emit(PendingMoneyRequestsError(message: failure.message)),
        (outgoingRequests) => emit(
          PendingMoneyRequestsLoaded(
            incomingRequests: incomingRequests,
            outgoingRequests: outgoingRequests,
            activeTab: activeTab,
          ),
        ),
      ),
    );
  }

  Future<void> _onApproveRequest(
    PendingMoneyRequestsApprove event,
    Emitter<PendingMoneyRequestsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PendingMoneyRequestsLoaded) return;

    emit(const PendingMoneyRequestsLoading());

    final walletTransferParams = WalletTransferParams(
      userQuery: event.request.fromAddress,
      amount: event.request.amount,
    );

    final walletTransferResult = await walletTransferUsecase.call(
      walletTransferParams,
    );

    return walletTransferResult.fold(
      (failure) => emit(PendingMoneyRequestsError(message: failure.message)),
      (walletTransfer) async {
        final deleteResult = await deleteRequestMoneyUsecase.call(
          event.requestId,
        );

        return deleteResult.fold(
          (failure) =>
              emit(PendingMoneyRequestsError(message: failure.message)),
          (_) {
            emit(
              PendingMoneyRequestsActionSuccess(
                message: LocaleKeys.money_request_approve_success.translate,
                navigateToTransfer: true,
                request: event.request,
                walletTransfer: walletTransfer,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onRejectRequest(
    PendingMoneyRequestsReject event,
    Emitter<PendingMoneyRequestsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PendingMoneyRequestsLoaded) return;

    emit(const PendingMoneyRequestsLoading());

    final result = await deleteRequestMoneyUsecase.call(event.requestId);

    return result.fold(
      (failure) => emit(PendingMoneyRequestsError(message: failure.message)),
      (_) async {
        final incomingResult = await getBuyerRequestMoneysUsecase.call();
        final outgoingResult = await getSenderRequestMoneysUsecase.call();
        return incomingResult.fold(
          (failure) =>
              emit(PendingMoneyRequestsError(message: failure.message)),
          (incomingRequests) => outgoingResult.fold(
            (failure) =>
                emit(PendingMoneyRequestsError(message: failure.message)),
            (outgoingRequests) {
              emit(
                PendingMoneyRequestsLoaded(
                  incomingRequests: incomingRequests,
                  outgoingRequests: outgoingRequests,
                  activeTab: currentState.activeTab,
                ),
              );
              emit(
                PendingMoneyRequestsActionSuccess(
                  message: LocaleKeys.money_request_reject_success.translate,
                  navigateToTransfer: false,
                  request: event.request,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _onDeleteRequest(
    PendingMoneyRequestsDelete event,
    Emitter<PendingMoneyRequestsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PendingMoneyRequestsLoaded) return;

    emit(const PendingMoneyRequestsLoading());

    final result = await deleteRequestMoneyUsecase.call(event.requestId);

    return result.fold(
      (failure) => emit(PendingMoneyRequestsError(message: failure.message)),
      (_) async {
        final incomingResult = await getBuyerRequestMoneysUsecase.call();
        final outgoingResult = await getSenderRequestMoneysUsecase.call();
        return incomingResult.fold(
          (failure) =>
              emit(PendingMoneyRequestsError(message: failure.message)),
          (incomingRequests) => outgoingResult.fold(
            (failure) =>
                emit(PendingMoneyRequestsError(message: failure.message)),
            (outgoingRequests) {
              emit(
                PendingMoneyRequestsLoaded(
                  incomingRequests: incomingRequests,
                  outgoingRequests: outgoingRequests,
                  activeTab: currentState.activeTab,
                ),
              );
              emit(
                PendingMoneyRequestsActionSuccess(
                  message: LocaleKeys.money_request_delete_success.translate,
                  navigateToTransfer: false,
                  request: event.request,
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _onTabChanged(
    PendingMoneyRequestsTabChanged event,
    Emitter<PendingMoneyRequestsState> emit,
  ) {
    final currentState = state;
    if (currentState is PendingMoneyRequestsLoaded) {
      emit(
        PendingMoneyRequestsLoaded(
          incomingRequests: currentState.incomingRequests,
          outgoingRequests: currentState.outgoingRequests,
          activeTab: event.tabIndex,
        ),
      );
    }
  }
}
