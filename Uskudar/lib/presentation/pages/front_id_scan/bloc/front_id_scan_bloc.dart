import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/params/front_image_check_params.dart';
import 'package:payinall/domain/usecases/front_image_check_usecase.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

part 'front_id_scan_event.dart';
part 'front_id_scan_state.dart';

final class FrontIdScanBloc extends Bloc<FrontIdScanEvent, FrontIdScanState> {
  FrontIdScanBloc({required FrontImageCheckUsecase frontImageCheckUsecase})
    : _frontImageCheckUsecase = frontImageCheckUsecase,
      super(const FrontIdScanState()) {
    on<FrontIdScanStart>(_onFrontIdScanStart);
    on<FrontIdScanEnd>(_onFrontIdScanEnd);
  }

  final FrontImageCheckUsecase _frontImageCheckUsecase;

  Future<void> _onFrontIdScanStart(
    FrontIdScanStart event,
    Emitter<FrontIdScanState> emit,
  ) async {
    emit(state.copyWith(status: FrontIdScanStatus.loading));
  }

  Future<void> _onFrontIdScanEnd(
    FrontIdScanEnd event,
    Emitter<FrontIdScanState> emit,
  ) async {
    if (event.image != null && event.image!.isNotEmpty) {
      final params = FrontImageCheckParams(image: event.image!);

      final result = await _frontImageCheckUsecase(params);

      result.fold(
        (l) {
          emit(
            state.copyWith(status: FrontIdScanStatus.error, message: l.message),
          );
        },
        (r) {
          emit(state.copyWith(status: FrontIdScanStatus.success, processId: r));
        },
      );
    } else {
      emit(
        state.copyWith(
          status: FrontIdScanStatus.error,
          message: LocaleKeys.front_id_scan_error.translate,
        ),
      );
    }
  }
}
