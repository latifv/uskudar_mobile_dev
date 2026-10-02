import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/campaign.dart';
import 'package:uskudar_mobile/domain/usecases/get_campaigns_usecase.dart';

part 'campaigns_event.dart';
part 'campaigns_state.dart';

final class CampaignsBloc extends Bloc<CampaignsEvent, CampaignsState> {
  CampaignsBloc({
    required GetCampaignsUsecase getCampaignsUsecase,
  }) : _getCampaignsUsecase = getCampaignsUsecase,
       super(const CampaignsState()) {
    on<CampaignsLoadData>(_onLoadData);
    on<CampaignsRefreshData>(_onRefreshData);
  }

  final GetCampaignsUsecase _getCampaignsUsecase;

  Future<void> _onLoadData(
    CampaignsLoadData event,
    Emitter<CampaignsState> emit,
  ) async {
    emit(state.copyWith(status: CampaignsStatus.loading));

    final result = await _getCampaignsUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CampaignsStatus.error,
          message: failure.message,
        ),
      ),
      (campaigns) => emit(
        state.copyWith(
          status: CampaignsStatus.loaded,
          campaigns: campaigns,
        ),
      ),
    );
  }

  Future<void> _onRefreshData(
    CampaignsRefreshData event,
    Emitter<CampaignsState> emit,
  ) async {
    emit(state.copyWith(status: CampaignsStatus.loading));
    final result = await _getCampaignsUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CampaignsStatus.error,
          message: failure.message,
        ),
      ),
      (campaigns) => emit(
        state.copyWith(
          status: CampaignsStatus.loaded,
          campaigns: campaigns,
        ),
      ),
    );
  }
}
