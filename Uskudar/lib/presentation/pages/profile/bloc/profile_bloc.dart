import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/domain/usecases/email_verification_send_code_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_current_user_info_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_wallet_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/logout_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/remove_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UserInfoManager userInfoManager,
    required GetCurrentUserInfoUsecase getCurrentUserInfoUsecase,
    required GetWalletUsecase getWalletUsecase,
    required LogoutUsecase logoutUsecase,
    required RemoveUsecase removeUsecase,
    required EmailVerificationSendCodeUsecase emailVerificationSendCodeUsecase,
  }) : _userInfoManager = userInfoManager,
       _getCurrentUserInfoUsecase = getCurrentUserInfoUsecase,
       _getWalletUsecase = getWalletUsecase,
       _logoutUsecase = logoutUsecase,
       _removeUsecase = removeUsecase,
       _emailVerificationSendCodeUsecase = emailVerificationSendCodeUsecase,
       super(const ProfileState()) {
    on<ProfileLoadData>(_onLoadData);
    on<ProfileLogout>(_onLogout);
    on<ProfileDeleteAccount>(_onDeleteAccount);
    on<ProfileCheckBalance>(_onCheckBalance);
    on<ProfileSendEmailUpdateCode>(_onSendEmailUpdateCode);
  }

  final UserInfoManager _userInfoManager;
  final GetCurrentUserInfoUsecase _getCurrentUserInfoUsecase;
  final GetWalletUsecase _getWalletUsecase;
  final LogoutUsecase _logoutUsecase;
  final RemoveUsecase _removeUsecase;
  final EmailVerificationSendCodeUsecase _emailVerificationSendCodeUsecase;

  Future<void> _onLoadData(
    ProfileLoadData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final firstName = _userInfoManager.firstName;
    final lastName = _userInfoManager.lastName;
    final walletAddress = _userInfoManager.walletAddress;
    final image = _userInfoManager.image;

    if (!event.refresh &&
        firstName != null &&
        lastName != null &&
        walletAddress != null) {
      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          name: firstName,
          surname: lastName,
          walletAddress: walletAddress,
          image: image,
        ),
      );
      return;
    }

    final currentUserInfo = await _getCurrentUserInfoUsecase();

    currentUserInfo.fold(
      (l) =>
          emit(state.copyWith(status: ProfileStatus.error, message: l.message)),
      (r) {
        _userInfoManager.setUserInfo(r);
        emit(
          state.copyWith(
            status: ProfileStatus.loaded,
            name: _userInfoManager.firstName ?? '',
            surname: _userInfoManager.lastName ?? '',
            walletAddress: _userInfoManager.walletAddress ?? '',
            image: _userInfoManager.image,
          ),
        );
      },
    );
  }

  Future<void> _onLogout(
    ProfileLogout event,
    Emitter<ProfileState> emit,
  ) async {
    _userInfoManager.clearUserInfo();
    await _logoutUsecase();
    emit(const ProfileState(status: ProfileStatus.loggedOut));
  }

  Future<void> _onDeleteAccount(
    ProfileDeleteAccount event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _removeUsecase();
    result.fold(
      (l) =>
          emit(state.copyWith(status: ProfileStatus.error, message: l.message)),
      (r) {
        emit(state.copyWith(status: ProfileStatus.loggedOut, message: r));
      },
    );
  }

  Future<void> _onCheckBalance(
    ProfileCheckBalance event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _getWalletUsecase();
    result.fold(
      (l) =>
          emit(state.copyWith(status: ProfileStatus.error, message: l.message)),
      (r) {
        final hasBalance = r.balance > 0;
        emit(
          state.copyWith(
            status: ProfileStatus.balanceChecked,
            balance: r.balance,
            hasBalance: hasBalance,
          ),
        );
      },
    );
  }

  Future<void> _onSendEmailUpdateCode(
    ProfileSendEmailUpdateCode event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _emailVerificationSendCodeUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.error,
          message: failure.message,
        ),
      ),
      (processCode) => emit(
        state.copyWith(
          status: ProfileStatus.emailUpdateCodeSent,
          emailProcessCode: processCode,
        ),
      ),
    );
  }
}
