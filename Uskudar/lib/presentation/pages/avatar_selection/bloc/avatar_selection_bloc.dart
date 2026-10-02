import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/domain/entities/avatar_image.dart';
import 'package:uskudar_mobile/domain/usecases/delete_customer_avatar_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_avatar_images_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/select_customer_avatar_usecase.dart';

part 'avatar_selection_event.dart';
part 'avatar_selection_state.dart';

final class AvatarSelectionBloc
    extends Bloc<AvatarSelectionEvent, AvatarSelectionState> {
  AvatarSelectionBloc({
    required GetAvatarImagesUsecase getAvatarImagesUsecase,
    required SelectCustomerAvatarUsecase selectCustomerAvatarUsecase,
    required DeleteCustomerAvatarUsecase deleteCustomerAvatarUsecase,
    required UserInfoManager userInfoManager,
  }) : _getAvatarImagesUsecase = getAvatarImagesUsecase,
       _selectCustomerAvatarUsecase = selectCustomerAvatarUsecase,
       _deleteCustomerAvatarUsecase = deleteCustomerAvatarUsecase,
       _userInfoManager = userInfoManager,
       super(const AvatarSelectionState()) {
    on<AvatarSelectionLoadImages>(_onLoadImages);
    on<AvatarSelectionSelect>(_onSelect);
    on<AvatarSelectionDeleteAvatar>(_onDeleteAvatar);
  }

  final GetAvatarImagesUsecase _getAvatarImagesUsecase;
  final SelectCustomerAvatarUsecase _selectCustomerAvatarUsecase;
  final DeleteCustomerAvatarUsecase _deleteCustomerAvatarUsecase;
  final UserInfoManager _userInfoManager;

  Future<void> _onLoadImages(
    AvatarSelectionLoadImages event,
    Emitter<AvatarSelectionState> emit,
  ) async {
    final hasAvatar =
        _userInfoManager.image != null &&
        (_userInfoManager.image?.isNotEmpty ?? false);

    emit(
      state.copyWith(
        status: AvatarSelectionStatus.loading,
        hasCurrentAvatar: hasAvatar,
      ),
    );

    final result = await _getAvatarImagesUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AvatarSelectionStatus.error,
          message: failure.message,
        ),
      ),
      (images) => emit(
        state.copyWith(
          status: AvatarSelectionStatus.loaded,
          avatarImages: images,
        ),
      ),
    );
  }

  Future<void> _onSelect(
    AvatarSelectionSelect event,
    Emitter<AvatarSelectionState> emit,
  ) async {
    final currentImages = state.avatarImages;
    emit(state.copyWith(status: AvatarSelectionStatus.selecting));

    final result = await _selectCustomerAvatarUsecase(event.avatarImageId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AvatarSelectionStatus.error,
          message: failure.message,
        ),
      ),
      (_) {
        final selectedAvatar = currentImages.firstWhere(
          (avatar) => avatar.id == event.avatarImageId,
          orElse: () => const AvatarImage(),
        );
        _userInfoManager.setImage(selectedAvatar.image);
        emit(
          state.copyWith(
            status: AvatarSelectionStatus.success,
            hasCurrentAvatar: selectedAvatar.image?.isNotEmpty ?? false,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteAvatar(
    AvatarSelectionDeleteAvatar event,
    Emitter<AvatarSelectionState> emit,
  ) async {
    emit(state.copyWith(status: AvatarSelectionStatus.deleting));

    final result = await _deleteCustomerAvatarUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AvatarSelectionStatus.error,
          message: failure.message,
        ),
      ),
      (_) {
        _userInfoManager.setImage(null);
        emit(
          state.copyWith(
            status: AvatarSelectionStatus.success,
            hasCurrentAvatar: false,
          ),
        );
      },
    );
  }
}
