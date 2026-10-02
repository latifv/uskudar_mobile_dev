import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:payinall/core/managers/signalr_manager.dart';
import 'package:payinall/core/services/firebase_service.dart';
import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/utils/log_level.dart';
import 'package:payinall/data/network/network_client.dart';
import 'package:payinall/di/di_module.dart';
import 'package:payinall/di/modules/bloc_module.dart';
import 'package:payinall/di/modules/critical_service_module.dart';
import 'package:payinall/di/modules/local_data_source_module.dart';
import 'package:payinall/di/modules/manager_module.dart';
import 'package:payinall/di/modules/network_module.dart';
import 'package:payinall/di/modules/remote_data_source_module.dart';
import 'package:payinall/di/modules/repository_module.dart';
import 'package:payinall/di/modules/router_module.dart';
import 'package:payinall/di/modules/service_module.dart';
import 'package:payinall/di/modules/usecase_module.dart';

final GetIt getIt = GetIt.instance;

final _criticalModules = <DIModule>[RouterModule(), CriticalServiceModule()];

final _nonCriticalModules = <DIModule>[
  ManagerModule(),
  LocalDataSourceModule(),
  NetworkModule(),
  RemoteDataSourceModule(),
  ServiceModule(),
  RepositoryModule(),
  UseCaseModule(),
  BlocModule(),
];

Future<void> setupCritical() async {
  for (final module in _criticalModules) {
    await module.setup(getIt);
  }
}

Future<void> setupNonCritical() async {
  for (final module in _nonCriticalModules) {
    await module.setup(getIt);
  }
}

Future<void> disposeDI() async {
  try {
    LogHelper.log(LogLevel.info, 'DI temizleme başlatılıyor...');

    await _performDispose().timeout(
      const Duration(seconds: 2),
      onTimeout: () {
        LogHelper.log(
          LogLevel.warning,
          'DI dispose timeout - zorla sonlandırılıyor',
        );
        unawaited(getIt.reset());
      },
    );
  } on Exception catch (e) {
    LogHelper.log(LogLevel.error, 'DI temizleme sırasında hata oluştu: $e');
    unawaited(getIt.reset());
  }
}

Future<void> _performDispose() async {
  final futures = <Future<void>>[];

  if (getIt.isRegistered<NetworkClient>()) {
    futures.add(
      Future.sync(() {
        getIt<NetworkClient>().dispose();
        LogHelper.log(LogLevel.debug, 'NetworkClient dispose edildi');
      }),
    );
  }

  if (getIt.isRegistered<SignalRManager>()) {
    futures.add(() async {
      final signalRManager = getIt<SignalRManager>();
      await signalRManager.dispose();
      LogHelper.log(LogLevel.debug, 'SignalRManager dispose edildi');
    }());
  }

  if (getIt.isRegistered<FirebaseService>()) {
    futures.add(() async {
      final firebaseService = getIt<FirebaseService>();
      await firebaseService.dispose();
      LogHelper.log(LogLevel.debug, 'FirebaseService dispose edildi');
    }());
  }

  await Future.wait(futures);
  await getIt.reset();

  LogHelper.log(LogLevel.info, 'DI temizleme başarıyla tamamlandı');
}
