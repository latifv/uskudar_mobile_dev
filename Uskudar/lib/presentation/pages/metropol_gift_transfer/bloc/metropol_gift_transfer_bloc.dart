import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/params/metropol_draw_back_transfer_params.dart';
import 'package:payinall/domain/params/metropol_gift_transfer_params.dart';
import 'package:payinall/domain/usecases/metropol_draw_back_transfer_usecase.dart';
import 'package:payinall/domain/usecases/metropol_gift_transfer_usecase.dart';

part 'metropol_gift_transfer_event.dart';
part 'metropol_gift_transfer_state.dart';

final class MetropolGiftTransferBloc
    extends Bloc<MetropolGiftTransferEvent, MetropolGiftTransferState> {
  MetropolGiftTransferBloc({
    required this.metropolGiftTransferUsecase,
    required this.metropolDrawBackTransferUsecase,
  }) : super(const MetropolGiftTransferState()) {
    on<MetropolGiftTransferSubmit>(_onSubmit);
    on<MetropolGiftTransferDrawBack>(_onDrawBack);
  }

  final MetropolGiftTransferUsecase metropolGiftTransferUsecase;
  final MetropolDrawBackTransferUsecase metropolDrawBackTransferUsecase;

  Future<void> _onSubmit(
    MetropolGiftTransferSubmit event,
    Emitter<MetropolGiftTransferState> emit,
  ) async {
    emit(state.copyWith(status: MetropolGiftTransferStatus.loading));

    final result = await metropolGiftTransferUsecase(
      MetropolGiftTransferParams(amount: event.amount),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MetropolGiftTransferStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: MetropolGiftTransferStatus.completed,
          message: message,
        ),
      ),
    );
  }

  Future<void> _onDrawBack(
    MetropolGiftTransferDrawBack event,
    Emitter<MetropolGiftTransferState> emit,
  ) async {
    emit(state.copyWith(status: MetropolGiftTransferStatus.loading));

    final result = await metropolDrawBackTransferUsecase(
      const MetropolDrawBackTransferParams(metropolType: 1),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MetropolGiftTransferStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: MetropolGiftTransferStatus.drawBackCompleted,
          message: message,
        ),
      ),
    );
  }
}
