import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/params/request_moneys_params.dart';
import 'package:uskudar_mobile/domain/usecases/request_money_usecase.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

part 'request_money_event.dart';
part 'request_money_state.dart';

final class RequestMoneyBloc
    extends Bloc<RequestMoneyEvent, RequestMoneyState> {
  RequestMoneyBloc({required RequestMoneyUsecase requestMoneyUsecase})
    : _requestMoneyUsecase = requestMoneyUsecase,
      super(const RequestMoneyState()) {
    on<RequestMoneyInitialize>(_onInitialize);
    on<RequestMoneyToggleMethod>(_onToggleMethod);
    on<RequestMoneySend>(_onSendRequest);
  }

  final RequestMoneyUsecase _requestMoneyUsecase;

  void _onInitialize(
    RequestMoneyInitialize event,
    Emitter<RequestMoneyState> emit,
  ) {
    emit(
      const RequestMoneyState(
        status: RequestMoneyStatus.ready,
        isPhoneMethod: true,
      ),
    );
  }

  void _onToggleMethod(
    RequestMoneyToggleMethod event,
    Emitter<RequestMoneyState> emit,
  ) {
    emit(
      state.copyWith(
        isPhoneMethod: event.isPhoneMethod,
        status: RequestMoneyStatus.ready,
      ),
    );
  }

  Future<void> _onSendRequest(
    RequestMoneySend event,
    Emitter<RequestMoneyState> emit,
  ) async {
    emit(state.copyWith(status: RequestMoneyStatus.loading));

    final money = event.amount.toDoubleFromCurrency();
    final recipient = state.isPhoneMethod
        ? event.phoneNumber ?? ''
        : event.walletAddress ?? '';

    final params = RequestMoneyParams(
      money: money,
      description: event.description ?? '',
      fromAddress: recipient,
    );

    final result = await _requestMoneyUsecase(params);

    result.fold(
      (l) => emit(
        state.copyWith(status: RequestMoneyStatus.error, message: l.message),
      ),
      (_) => emit(
        state.copyWith(
          status: RequestMoneyStatus.success,
          requestAmount: event.amount,
          requestRecipient: recipient,
        ),
      ),
    );
  }
}
