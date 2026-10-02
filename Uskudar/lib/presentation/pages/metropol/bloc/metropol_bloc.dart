import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/metropol_user_balance.dart';
import 'package:uskudar_mobile/domain/entities/metropol_user_detail.dart';
import 'package:uskudar_mobile/domain/usecases/create_metropol_user_or_detail_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_metropol_user_balance_usecase.dart';

part 'metropol_event.dart';
part 'metropol_state.dart';

final class MetropolBloc extends Bloc<MetropolEvent, MetropolState> {
  MetropolBloc({
    required this.createMetropolUserOrDetailUsecase,
    required this.getMetropolUserBalanceUsecase,
  }) : super(const MetropolState()) {
    on<MetropolLoad>(_onLoad);
    on<MetropolRefreshBalance>(_onRefreshBalance);
  }

  final CreateMetropolUserOrDetailUsecase createMetropolUserOrDetailUsecase;
  final GetMetropolUserBalanceUsecase getMetropolUserBalanceUsecase;

  Future<void> _onLoad(
    MetropolLoad event,
    Emitter<MetropolState> emit,
  ) async {
    emit(state.copyWith(status: MetropolStatus.loading));

    final userResult = await createMetropolUserOrDetailUsecase();

    final userFailed = userResult.isLeft();
    if (userFailed) {
      final failure = userResult.getLeft().toNullable();
      emit(
        state.copyWith(
          status: MetropolStatus.error,
          message: failure?.message,
        ),
      );
      return;
    }

    final userDetail = userResult.getRight().toNullable();

    final balanceResult = await getMetropolUserBalanceUsecase();

    final balanceFailed = balanceResult.isLeft();
    if (balanceFailed) {
      final failure = balanceResult.getLeft().toNullable();
      emit(
        state.copyWith(
          status: MetropolStatus.error,
          message: failure?.message,
          userDetail: userDetail,
        ),
      );
      return;
    }

    final balance = balanceResult.getRight().toNullable();

    emit(
      state.copyWith(
        status: MetropolStatus.loaded,
        userDetail: userDetail,
        balance: balance,
      ),
    );
  }

  Future<void> _onRefreshBalance(
    MetropolRefreshBalance event,
    Emitter<MetropolState> emit,
  ) async {
    final balanceResult = await getMetropolUserBalanceUsecase();

    balanceResult.fold(
      (failure) => emit(
        state.copyWith(
          status: MetropolStatus.error,
          message: failure.message,
        ),
      ),
      (balance) => emit(
        state.copyWith(
          status: MetropolStatus.loaded,
          balance: balance,
        ),
      ),
    );
  }
}
