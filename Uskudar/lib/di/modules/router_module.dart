import 'package:get_it/get_it.dart';
import 'package:uskudar_mobile/di/di_module.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';

final class RouterModule extends DIModule {
  @override
  Future<void> setup(GetIt getIt) async {
    getIt.registerSingleton(AppRouter());
  }
}
