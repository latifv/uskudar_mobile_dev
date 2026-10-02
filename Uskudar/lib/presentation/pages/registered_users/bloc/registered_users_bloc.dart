import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/domain/entities/frequent_iban.dart';
import 'package:uskudar_mobile/domain/entities/frequently_sent.dart';
import 'package:uskudar_mobile/domain/params/add_frequent_iban_params.dart';
import 'package:uskudar_mobile/domain/usecases/add_frequent_iban_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/add_frequently_sent_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/delete_frequent_iban_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/delete_frequently_sent_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_frequent_ibans_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_frequently_sents_usecase.dart';

part 'registered_users_event.dart';
part 'registered_users_state.dart';

final class RegisteredUsersBloc
    extends Bloc<RegisteredUsersEvent, RegisteredUsersState> {
  RegisteredUsersBloc({
    required this.addFrequentlySentUsecase,
    required this.deleteFrequentlySentUsecase,
    required this.getFrequentlySentsUsecase,
    required this.getFrequentIbansUsecase,
    required this.addFrequentIbanUsecase,
    required this.deleteFrequentIbanUsecase,
    required this.userInfoManager,
  }) : super(const RegisteredUsersState()) {
    on<RegisteredUsersLoad>(_onLoad);
    on<RegisteredUsersAddUser>(_onAddUser);
    on<RegisteredUsersDeleteUser>(_onDeleteUser);
    on<RegisteredUsersAddIban>(_onAddIban);
    on<RegisteredUsersDeleteIban>(_onDeleteIban);
    on<RegisteredUsersTabChanged>(_onTabChanged);
  }

  final AddFrequentlySentUsecase addFrequentlySentUsecase;
  final DeleteFrequentlySentUsecase deleteFrequentlySentUsecase;
  final GetFrequentlySentsUsecase getFrequentlySentsUsecase;
  final GetFrequentIbansUsecase getFrequentIbansUsecase;
  final AddFrequentIbanUsecase addFrequentIbanUsecase;
  final DeleteFrequentIbanUsecase deleteFrequentIbanUsecase;
  final UserInfoManager userInfoManager;

  Future<void> _onLoad(
    RegisteredUsersLoad event,
    Emitter<RegisteredUsersState> emit,
  ) async {
    emit(state.copyWith(status: RegisteredUsersStatus.loading));

    if (userInfoManager.isMerchant) {
      final ibansResult = await getFrequentIbansUsecase();
      ibansResult.fold(
        (failure) => emit(
          state.copyWith(
            status: RegisteredUsersStatus.error,
            message: failure.message,
          ),
        ),
        (ibans) => emit(
          state.copyWith(
            status: RegisteredUsersStatus.loaded,
            frequentIbans: ibans,
          ),
        ),
      );
    } else {
      final sentsResult = await getFrequentlySentsUsecase();
      sentsResult.fold(
        (failure) => emit(
          state.copyWith(
            status: RegisteredUsersStatus.error,
            message: failure.message,
          ),
        ),
        (sents) => emit(
          state.copyWith(
            status: RegisteredUsersStatus.loaded,
            frequentlySents: sents,
          ),
        ),
      );
    }
  }

  Future<void> _onAddUser(
    RegisteredUsersAddUser event,
    Emitter<RegisteredUsersState> emit,
  ) async {
    emit(state.copyWith(status: RegisteredUsersStatus.loading));

    final result = await addFrequentlySentUsecase(event.customerNumber);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RegisteredUsersStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: RegisteredUsersStatus.actionSuccess,
          message: message,
        ),
      ),
    );
  }

  Future<void> _onDeleteUser(
    RegisteredUsersDeleteUser event,
    Emitter<RegisteredUsersState> emit,
  ) async {
    emit(state.copyWith(status: RegisteredUsersStatus.loading));

    final result = await deleteFrequentlySentUsecase(event.id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RegisteredUsersStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: RegisteredUsersStatus.actionSuccess,
          message: message,
        ),
      ),
    );
  }

  Future<void> _onAddIban(
    RegisteredUsersAddIban event,
    Emitter<RegisteredUsersState> emit,
  ) async {
    emit(state.copyWith(status: RegisteredUsersStatus.loading));

    final params = AddFrequentIbanParams(
      ibanNo: event.ibanNo,
      firstName: event.firstName,
      lastName: event.lastName,
    );

    final result = await addFrequentIbanUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RegisteredUsersStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: RegisteredUsersStatus.actionSuccess,
          message: message,
        ),
      ),
    );
  }

  Future<void> _onDeleteIban(
    RegisteredUsersDeleteIban event,
    Emitter<RegisteredUsersState> emit,
  ) async {
    emit(state.copyWith(status: RegisteredUsersStatus.loading));

    final result = await deleteFrequentIbanUsecase(event.id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RegisteredUsersStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: RegisteredUsersStatus.actionSuccess,
          message: message,
        ),
      ),
    );
  }

  void _onTabChanged(
    RegisteredUsersTabChanged event,
    Emitter<RegisteredUsersState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tabIndex));
  }
}
