import 'package:get_it/get_it.dart';
import 'package:uskudar_mobile/core/managers/signalr_manager.dart';
import 'package:uskudar_mobile/core/managers/token_manager.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/di/di_module.dart';

final class ManagerModule extends DIModule {
  @override
  Future<void> setup(GetIt getIt) async {
    getIt
      ..registerLazySingleton<TokenManager>(TokenManager.new)
      ..registerLazySingleton<UserInfoManager>(UserInfoManager.new)
      ..registerLazySingleton<SignalRManager>(
        () => SignalRManagerImpl(
          signalRService: getIt(),
          tokenManager: getIt(),
        ),
      );
  }
}
