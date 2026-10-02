import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/user_address_information.dart';
import 'package:uskudar_mobile/domain/params/get_user_address_information_params.dart';
import 'package:uskudar_mobile/domain/params/user_address_information_approve_params.dart';
import 'package:uskudar_mobile/domain/usecases/get_user_address_information_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/user_address_information_approve_usecase.dart';

part 'address_preview_event.dart';
part 'address_preview_state.dart';

final class AddressPreviewBloc
    extends Bloc<AddressPreviewEvent, AddressPreviewState> {
  AddressPreviewBloc({
    required this.getUserAddressInformationUsecase,
    required this.userAddressInformationApproveUsecase,
  }) : super(const AddressPreviewState()) {
    on<AddressPreviewStarted>(_onAddressPreviewStarted);
    on<AddressPreviewApproved>(_onAddressPreviewApproved);
  }

  final GetUserAddressInformationUsecase getUserAddressInformationUsecase;
  final UserAddressInformationApproveUsecase
  userAddressInformationApproveUsecase;

  Future<void> _onAddressPreviewStarted(
    AddressPreviewStarted event,
    Emitter<AddressPreviewState> emit,
  ) async {
    emit(state.copyWith(status: AddressPreviewStatus.loading));

    const params = GetUserAddressInformationParams();
    final result = await getUserAddressInformationUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddressPreviewStatus.error,
          message: failure.message,
        ),
      ),
      (userAddressInformation) => emit(
        state.copyWith(
          status: AddressPreviewStatus.loaded,
          userAddressInformation: userAddressInformation,
        ),
      ),
    );
  }

  Future<void> _onAddressPreviewApproved(
    AddressPreviewApproved event,
    Emitter<AddressPreviewState> emit,
  ) async {
    if (state.status == AddressPreviewStatus.processing) {
      return;
    }

    emit(state.copyWith(status: AddressPreviewStatus.processing));

    final params = UserAddressInformationApproveParams(
      isManuel: event.isManuel,
      address: event.address,
    );
    final result = await userAddressInformationApproveUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddressPreviewStatus.error,
          message: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: AddressPreviewStatus.approved)),
    );
  }
}
