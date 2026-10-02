import 'package:get_it/get_it.dart';
import 'package:uskudar_mobile/core/services/firebase_service.dart';
import 'package:uskudar_mobile/core/services/local_notification_service.dart';
import 'package:uskudar_mobile/di/di_module.dart';

final class CriticalServiceModule extends DIModule {
  @override
  Future<void> setup(GetIt getIt) async {
    getIt
      ..registerSingleton<LocalNotificationService>(
        LocalNotificationServiceImpl(),
      )
      ..registerSingleton<FirebaseService>(FirebaseServiceImpl());
  }
}
