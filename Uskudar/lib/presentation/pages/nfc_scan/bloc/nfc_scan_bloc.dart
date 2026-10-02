import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/nfc_identity.dart';
import 'package:payinall/domain/params/nfc_check_params.dart';
import 'package:payinall/domain/usecases/nfc_check_usecase.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

part 'nfc_scan_event.dart';
part 'nfc_scan_state.dart';

final class NfcScanBloc extends Bloc<NfcScanEvent, NfcScanState> {
  NfcScanBloc({required NfcCheckUsecase nfcCheckUsecase})
    : _nfcCheckUsecase = nfcCheckUsecase,
      super(const NfcScanState()) {
    on<NfcScanStart>(_onNfcScanStart);
    on<NfcScanEnd>(_onNfcScanEnd);
  }

  final NfcCheckUsecase _nfcCheckUsecase;

  Future<void> _onNfcScanStart(
    NfcScanStart event,
    Emitter<NfcScanState> emit,
  ) async {
    emit(state.copyWith(status: NfcScanStatus.loading));
  }

  Future<void> _onNfcScanEnd(
    NfcScanEnd event,
    Emitter<NfcScanState> emit,
  ) async {
    if (event.nfcData != null) {
      final params = NfcCheckParams(
        dg1Base64: event.nfcData!.dg1Base64,
        dg2Base64: event.nfcData!.dg2Base64,
        dg3Base64: event.nfcData!.dg3Base64,
        dg4Base64: event.nfcData!.dg4Base64,
        dg5Base64: event.nfcData!.dg5Base64,
        dg6Base64: event.nfcData!.dg6Base64,
        dg7Base64: event.nfcData!.dg7Base64,
        dg8Base64: event.nfcData!.dg8Base64,
        dg9Base64: event.nfcData!.dg9Base64,
        dg10Base64: event.nfcData!.dg10Base64,
        dg11Base64: event.nfcData!.dg11Base64,
        dg12Base64: event.nfcData!.dg12Base64,
        dg13Base64: event.nfcData!.dg13Base64,
        dg14Base64: event.nfcData!.dg14Base64,
        dg15Base64: event.nfcData!.dg15Base64,
        dg16Base64: event.nfcData!.dg16Base64,
        efComBase64: event.nfcData!.efComBase64,
        activeAuthenticationResponseBase64:
            event.nfcData!.activeAuthenticationResponseBase64,
        challengeBase64: event.nfcData!.challangeBase64,
        efSodBase64: event.nfcData!.efSodBase64,
        processId: event.processId,
        mrz: event.mrz,
      );

      final result = await _nfcCheckUsecase(params);

      result.fold(
        (l) {
          emit(state.copyWith(status: NfcScanStatus.error, message: l.message));
        },
        (r) {
          emit(state.copyWith(status: NfcScanStatus.success, image: r.image));
        },
      );
    } else {
      emit(
        state.copyWith(
          status: NfcScanStatus.error,
          message: LocaleKeys.nfc_scan_error.translate,
        ),
      );
    }
  }
}
