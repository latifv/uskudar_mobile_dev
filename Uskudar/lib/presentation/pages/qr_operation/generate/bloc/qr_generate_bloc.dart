import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/constants/app_constants.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/services/qr_code_service/qr_code_service.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

part 'qr_generate_event.dart';
part 'qr_generate_state.dart';

final class QrGenerateBloc extends Bloc<QrGenerateEvent, QrGenerateState> {
  QrGenerateBloc({required this.qrCodeService})
    : super(const QrGenerateInitial()) {
    on<QrGenerateFormSubmitted>(_onFormSubmitted);
  }

  final QRCodeService qrCodeService;

  Future<void> _onFormSubmitted(
    QrGenerateFormSubmitted event,
    Emitter<QrGenerateState> emit,
  ) async {
    final amount = event.amount;

    emit(const QrGenerateLoading());

    final qrImage = await qrCodeService.generateQRCode(
      data: AppConstants.qrCodeDeepLinkFormat(event.walletAddress, amount),
      color: event.qrColor,
    );

    if (qrImage == null) {
      emit(
        QrGenerateError(
          message: LocaleKeys.qr_generate_error_message.translate,
        ),
      );
      return;
    }

    emit(QrGenerateSuccess(qrImage: qrImage, amount: amount));
  }
}
