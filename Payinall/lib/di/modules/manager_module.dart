import 'package:get_it/get_it.dart';
import 'package:payinall/core/managers/signalr_manager.dart';
import 'package:payinall/core/managers/token_manager.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/di/di_module.dart';

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
