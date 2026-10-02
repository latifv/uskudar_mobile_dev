import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/metropol_transfer_result.dart';
import 'package:uskudar_mobile/domain/params/metropol_draw_back_transfer_params.dart';
import 'package:uskudar_mobile/domain/params/metropol_transfer_complete_params.dart';
import 'package:uskudar_mobile/domain/params/metropol_transfer_params.dart';
import 'package:uskudar_mobile/domain/usecases/metropol_draw_back_transfer_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/metropol_transfer_complete_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/metropol_transfer_usecase.dart';

part 'metropol_transfer_event.dart';
part 'metropol_transfer_state.dart';

final class MetropolTransferBloc
    extends Bloc<MetropolTransferEvent, MetropolTransferState> {
  MetropolTransferBloc({
    required this.metropolTransferUsecase,
    required this.metropolTransferCompleteUsecase,
    required this.metropolDrawBackTransferUsecase,
  }) : super(const MetropolTransferState()) {
    on<MetropolTransferSubmit>(_onSubmit);
    on<MetropolTransferConfirm>(_onConfirm);
    on<MetropolTransferDrawBack>(_onDrawBack);
  }

  final MetropolTransferUsecase metropolTransferUsecase;
  final MetropolTransferCompleteUsecase metropolTransferCompleteUsecase;
  final MetropolDrawBackTransferUsecase metropolDrawBackTransferUsecase;

  Future<void> _onSubmit(
    MetropolTransferSubmit event,
    Emitter<MetropolTransferState> emit,
  ) async {
    emit(state.copyWith(status: MetropolTransferStatus.loading));

    final result = await metropolTransferUsecase(
      MetropolTransferParams(
        codeTypes: event.codeTypes,
        code: event.code,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MetropolTransferStatus.error,
          message: failure.message,
        ),
      ),
      (transferResult) => emit(
        state.copyWith(
          status: MetropolTransferStatus.transferReady,
          transferResult: transferResult,
        ),
      ),
    );
  }

  Future<void> _onConfirm(
    MetropolTransferConfirm event,
    Emitter<MetropolTransferState> emit,
  ) async {
    emit(state.copyWith(status: MetropolTransferStatus.confirming));

    final result = await metropolTransferCompleteUsecase(
      MetropolTransferCompleteParams(transactionId: event.transactionId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MetropolTransferStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: MetropolTransferStatus.completed,
          message: message,
        ),
      ),
    );
  }

  Future<void> _onDrawBack(
    MetropolTransferDrawBack event,
    Emitter<MetropolTransferState> emit,
  ) async {
    emit(state.copyWith(status: MetropolTransferStatus.loading));

    final result = await metropolDrawBackTransferUsecase(
      const MetropolDrawBackTransferParams(metropolType: 0),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MetropolTransferStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: MetropolTransferStatus.drawBackCompleted,
          message: message,
        ),
      ),
    );
  }
}
