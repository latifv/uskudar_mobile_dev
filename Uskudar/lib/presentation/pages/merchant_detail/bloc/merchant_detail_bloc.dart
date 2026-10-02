import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/domain/params/create_card_params.dart';
import 'package:uskudar_mobile/domain/usecases/create_card_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/create_qr_code_usecase.dart';

part 'merchant_detail_event.dart';
part 'merchant_detail_state.dart';

final class MerchantDetailBloc
    extends Bloc<MerchantDetailEvent, MerchantDetailState> {
  MerchantDetailBloc({
    required CreateCardUsecase createCardUsecase,
    required CreateQrCodeUsecase createQrCodeUsecase,
    required UserInfoManager userInfoManager,
  }) : _createCardUsecase = createCardUsecase,
       _createQrCodeUsecase = createQrCodeUsecase,
       _userInfoManager = userInfoManager,
       super(const MerchantDetailState()) {
    on<MerchantDetailCreateCard>(_onMerchantDetailCreateCard);
    on<MerchantDetailCreateQrCode>(_onMerchantDetailCreateQrCode);
  }

  final CreateCardUsecase _createCardUsecase;
  final CreateQrCodeUsecase _createQrCodeUsecase;
  final UserInfoManager _userInfoManager;

  Future<void> _onMerchantDetailCreateCard(
    MerchantDetailCreateCard event,
    Emitter<MerchantDetailState> emit,
  ) async {
    if (state.status == MerchantDetailStatus.processing) {
      return;
    }

    emit(state.copyWith(status: MerchantDetailStatus.processing));

    const params = CreateCardParams(
      individualFrameworkAgreement: true,
      preliminaryInformationAgreement: true,
      commercialElectronicCommunicationAgreement: true,
      kvkkAgreement: true,
    );

    final result = await _createCardUsecase(params);
    result.fold(
      (l) => emit(
        state.copyWith(
          status: MerchantDetailStatus.error,
          message: l.message,
        ),
      ),
      (r) {
        _userInfoManager.setIsExWallet(true);
        emit(state.copyWith(status: MerchantDetailStatus.cardSuccess));
      },
    );
  }

  Future<void> _onMerchantDetailCreateQrCode(
    MerchantDetailCreateQrCode event,
    Emitter<MerchantDetailState> emit,
  ) async {
    if (state.status == MerchantDetailStatus.processing) {
      return;
    }

    emit(state.copyWith(status: MerchantDetailStatus.processing));
    final result = await _createQrCodeUsecase.call();
    result.fold(
      (l) => emit(
        state.copyWith(status: MerchantDetailStatus.error, message: l.message),
      ),
      (r) => emit(
        state.copyWith(status: MerchantDetailStatus.qrCodeSuccess, qrCode: r),
      ),
    );
  }
}
