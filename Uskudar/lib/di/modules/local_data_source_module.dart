import 'package:get_it/get_it.dart';
import 'package:uskudar_mobile/data/datasources/local/app_local_data_source.dart';
import 'package:uskudar_mobile/data/datasources/local/auth_local_data_source.dart';
import 'package:uskudar_mobile/data/datasources/local/customers_local_data_source.dart';
import 'package:uskudar_mobile/data/datasources/local/notification_local_data_source.dart';
import 'package:uskudar_mobile/di/di_module.dart';

final class LocalDataSourceModule extends DIModule {
  @override
  Future<void> setup(GetIt getIt) async {
    getIt
      ..registerSingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl())
      ..registerSingleton<AppLocalDataSource>(AppLocalDataSourceImpl())
      ..registerSingleton<NotificationLocalDataSource>(
        NotificationLocalDataSourceImpl(),
      )
      ..registerLazySingleton<CustomersLocalDataSource>(
        CustomersLocalDataSourceImpl.new,
      );
  }
}
