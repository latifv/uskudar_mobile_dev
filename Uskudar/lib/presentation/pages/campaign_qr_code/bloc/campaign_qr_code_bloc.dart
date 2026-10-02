import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/usecases/create_qr_code_usecase.dart';

part 'campaign_qr_code_event.dart';
part 'campaign_qr_code_state.dart';

final class CampaignQrCodeBloc
    extends Bloc<CampaignQrCodeEvent, CampaignQrCodeState> {
  CampaignQrCodeBloc({
    required CreateQrCodeUsecase createQrCodeUsecase,
  }) : _createQrCodeUsecase = createQrCodeUsecase,
       super(const CampaignQrCodeInitial()) {
    on<CampaignQrCodeStarted>(_onStarted);
    on<CampaignQrCodeTimerTicked>(_onTimerTicked);
    on<CampaignQrCodeExpired>(_onExpired);
    on<CampaignQrCodeRegenerateRequested>(_onRegenerateRequested);
  }

  final CreateQrCodeUsecase _createQrCodeUsecase;

  static const int _initialSeconds = 300;
  Future<void> _onStarted(
    CampaignQrCodeStarted event,
    Emitter<CampaignQrCodeState> emit,
  ) async {
    emit(
      CampaignQrCodeLoaded(
        qrCode: event.qrCode,
        remainingSeconds: _initialSeconds,
      ),
    );
  }

  Future<void> _onTimerTicked(
    CampaignQrCodeTimerTicked event,
    Emitter<CampaignQrCodeState> emit,
  ) async {
    if (state is CampaignQrCodeLoaded) {
      final currentState = state as CampaignQrCodeLoaded;

      if (event.remainingSeconds <= 0) {
        add(const CampaignQrCodeExpired());
      } else {
        emit(
          CampaignQrCodeLoaded(
            qrCode: currentState.qrCode,
            remainingSeconds: event.remainingSeconds,
          ),
        );
      }
    }
  }

  Future<void> _onExpired(
    CampaignQrCodeExpired event,
    Emitter<CampaignQrCodeState> emit,
  ) async {
    add(const CampaignQrCodeRegenerateRequested());
  }

  Future<void> _onRegenerateRequested(
    CampaignQrCodeRegenerateRequested event,
    Emitter<CampaignQrCodeState> emit,
  ) async {
    emit(const CampaignQrCodeRegenerating());

    final result = await _createQrCodeUsecase.call();

    result.fold(
      (failure) => emit(
        CampaignQrCodeRegenerationFailed(message: failure.message),
      ),
      (qrCode) => emit(
        CampaignQrCodeLoaded(
          qrCode: qrCode,
          remainingSeconds: _initialSeconds,
        ),
      ),
    );
  }
}
