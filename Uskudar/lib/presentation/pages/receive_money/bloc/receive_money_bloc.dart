import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/usecases/get_transfer_info_usecase.dart';
import 'package:uskudar_mobile/presentation/pages/receive_money/bloc/receive_money_event.dart';
import 'package:uskudar_mobile/presentation/pages/receive_money/bloc/receive_money_state.dart';

final class ReceiveMoneyBloc extends Bloc<ReceiveMoneyEvent, ReceiveMoneyState> {
  ReceiveMoneyBloc({required this.getTransferInfoUsecase})
      : super(const ReceiveMoneyState()) {
    on<ReceiveMoneySubmitted>(_onSubmitted);
  }

  final GetTransferInfoUsecase getTransferInfoUsecase;

  Future<void> _onSubmitted(
    ReceiveMoneySubmitted event,
    Emitter<ReceiveMoneyState> emit,
  ) async {
    emit(state.copyWith(status: ReceiveMoneyStatus.loading));

    final result = await getTransferInfoUsecase(event.referenceNumber);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ReceiveMoneyStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: ReceiveMoneyStatus.success,
          message: message,
        ),
      ),
    );
  }
}
