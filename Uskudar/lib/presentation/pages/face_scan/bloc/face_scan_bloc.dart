import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/params/face_image_check_params.dart';
import 'package:uskudar_mobile/domain/usecases/face_image_check_usecase.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

part 'face_scan_event.dart';
part 'face_scan_state.dart';

final class FaceScanBloc extends Bloc<FaceScanEvent, FaceScanState> {
  FaceScanBloc({required FaceImageCheckUsecase faceImageCheckUsecase})
    : _faceImageCheckUsecase = faceImageCheckUsecase,
      super(const FaceScanState()) {
    on<FaceScanAgreementsCompleted>(_onFaceScanAgreementsCompleted);
    on<FaceScanStart>(_onFaceScanStart);
    on<FaceScanEnd>(_onFaceScanEnd);
  }

  final FaceImageCheckUsecase _faceImageCheckUsecase;

  Future<void> _onFaceScanAgreementsCompleted(
    FaceScanAgreementsCompleted event,
    Emitter<FaceScanState> emit,
  ) async {
    emit(state.copyWith(status: FaceScanStatus.agreementsCompleted));
  }

  Future<void> _onFaceScanStart(
    FaceScanStart event,
    Emitter<FaceScanState> emit,
  ) async {
    emit(state.copyWith(status: FaceScanStatus.loading));
  }

  Future<void> _onFaceScanEnd(
    FaceScanEnd event,
    Emitter<FaceScanState> emit,
  ) async {
    if (event.faceImageList.isNotEmpty) {
      final params = FaceImageCheckParams(
        processId: event.processId,
        faceImage: event.image,
        faceImageList: event.faceImageList,
      );

      final result = await _faceImageCheckUsecase(params);

      result.fold(
        (l) {
          emit(
            state.copyWith(status: FaceScanStatus.error, message: l.message),
          );
        },
        (r) {
          emit(state.copyWith(status: FaceScanStatus.success));
        },
      );
    } else {
      emit(
        state.copyWith(
          status: FaceScanStatus.error,
          message: LocaleKeys.face_scan_error.translate,
        ),
      );
    }
  }
}
