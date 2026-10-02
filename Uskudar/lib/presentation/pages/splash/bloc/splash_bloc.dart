import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/services/firebase_service.dart';
import 'package:uskudar_mobile/core/services/root_check_service.dart';
import 'package:uskudar_mobile/domain/entities/logged_in.dart';
import 'package:uskudar_mobile/domain/usecases/get_contracts_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_is_first_run_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_logged_in_usecase.dart';

part 'splash_event.dart';
part 'splash_state.dart';

final class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({
    required this.getIsFirstRunUsecase,
    required this.getLoggedInUsecase,
    required this.firebaseService,
    required this.getContractsUsecase,
    required this.rootCheckService,
  }) : super(const SplashInitial()) {
    on<SplashInitServices>(_onSplashInitServices);
    on<_SplashStarted>(_onSplashStarted);
  }

  final GetIsFirstRunUsecase getIsFirstRunUsecase;
  final GetLoggedInUsecase getLoggedInUsecase;
  final FirebaseService firebaseService;
  final GetContractsUsecase getContractsUsecase;
  final RootCheckService rootCheckService;
  Future<void> _onSplashInitServices(
    SplashInitServices event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoading());

    if (!kDebugMode) {
      final isRooted = await rootCheckService.isDeviceRooted();
      if (isRooted) {
        emit(const SplashJailbroken());
        return;
      }
    }

    await _initializeCrashlytics();

    add(const _SplashStarted());
  }

  Future<void> _onSplashStarted(
    _SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    final isFirstRun = await getIsFirstRunUsecase();
    await isFirstRun.fold(
      (failure) async => emit(SplashError(message: failure.message)),
      (isFirstRun) async {
        if (isFirstRun) {
          emit(const SplashLanguageSelection());
        } else {
          final loggedIn = await getLoggedInUsecase();
          await loggedIn.fold(
            (failure) async => emit(SplashError(message: failure.message)),
            (loggedIn) async {
              if (loggedIn != null) {
                await _setUserForCrashlytics(loggedIn);
                emit(SplashLoggedIn(loggedIn: loggedIn));
              } else {
                emit(const SplashNotLoggedIn());
              }
            },
          );
        }
      },
    );
  }

  Future<void> _initializeCrashlytics() async {
    await firebaseService.initializeCrashlytics();
    await firebaseService.crashlyticsLog('Uygulama başlatıldı.');
  }

  Future<void> _setUserForCrashlytics(LoggedIn loggedIn) async {
    if (loggedIn.identifier.isNotEmpty) {
      await firebaseService.setUserIdentifier(loggedIn.identifier);
    }
  }
}
