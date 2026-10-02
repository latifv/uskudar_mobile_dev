import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/presentation/pages/campaign_qr_code/bloc/campaign_qr_code_bloc.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';

mixin CampaignQrCodeMixin<T extends StatefulWidget> on State<T> {
  late final CampaignQrCodeBloc bloc;
  Timer? _timer;
  StreamSubscription<CampaignQrCodeState>? _blocSubscription;

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_blocSubscription?.cancel());
    unawaited(bloc.close());
    super.dispose();
  }

  void onLoadQrData({required String qrCode}) {
    bloc.add(CampaignQrCodeStarted(qrCode: qrCode));
    _setupBlocListener();
    _startTimer();
  }

  void _setupBlocListener() {
    _blocSubscription = bloc.stream.listen((state) {
      if (state is CampaignQrCodeLoaded) {
        _startTimer();
      } else if (state is CampaignQrCodeRegenerationFailed) {
        _onQrCodeRegenerationFailed(state.message);
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final currentState = bloc.state;
        if (currentState is CampaignQrCodeLoaded) {
          final newSeconds = currentState.remainingSeconds - 1;
          bloc.add(CampaignQrCodeTimerTicked(remainingSeconds: newSeconds));
        }
      },
    );
  }

  void _onQrCodeRegenerationFailed(String message) {
    ToastComponent.showErrorToast(
      context: context,
      message: message,
    );
    context.router.pop();
  }

  void onClosePressed() {
    context.router.pop();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
