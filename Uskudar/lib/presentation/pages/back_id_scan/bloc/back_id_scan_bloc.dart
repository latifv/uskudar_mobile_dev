import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/params/back_image_check_params.dart';
import 'package:uskudar_mobile/domain/usecases/back_image_check_usecase.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

part 'back_id_scan_event.dart';
part 'back_id_scan_state.dart';

final class BackIdScanBloc extends Bloc<BackIdScanEvent, BackIdScanState> {
  BackIdScanBloc({required BackImageCheckUsecase backImageCheckUsecase})
    : _backImageCheckUsecase = backImageCheckUsecase,
      super(const BackIdScanState()) {
    on<BackIdScanStart>(_onBackIdScanStart);
    on<BackIdScanEnd>(_onBackIdScanEnd);
  }

  final BackImageCheckUsecase _backImageCheckUsecase;

  Future<void> _onBackIdScanStart(
    BackIdScanStart event,
    Emitter<BackIdScanState> emit,
  ) async {
    emit(state.copyWith(status: BackIdScanStatus.loading));
  }

  Future<void> _onBackIdScanEnd(
    BackIdScanEnd event,
    Emitter<BackIdScanState> emit,
  ) async {
    if (event.image != null && event.image!.isNotEmpty) {
      final params = BackImageCheckParams(
        image: event.image!,
        processId: event.processId,
      );

      final result = await _backImageCheckUsecase(params);

      result.fold(
        (l) {
          emit(
            state.copyWith(status: BackIdScanStatus.error, message: l.message),
          );
        },
        (r) {
          emit(state.copyWith(status: BackIdScanStatus.success));
        },
      );
    } else {
      emit(
        state.copyWith(
          status: BackIdScanStatus.error,
          message: LocaleKeys.back_id_scan_error.translate,
        ),
      );
    }
  }
}
