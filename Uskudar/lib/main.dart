import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uskudar_mobile/app.dart';
import 'package:uskudar_mobile/core/constants/localization_constants.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';
import 'package:uskudar_mobile/core/utils/log_level.dart';
import 'package:uskudar_mobile/data/config/environment_config.dart';
import 'package:uskudar_mobile/data/datasources/local/app_local_data_source.dart';
import 'package:uskudar_mobile/data/local_storage/hive_boxes.dart';
import 'package:uskudar_mobile/data/models/auth_token_model.dart';
import 'package:uskudar_mobile/data/models/logged_in_model.dart';
import 'package:uskudar_mobile/data/models/notification_item_model.dart';
import 'package:uskudar_mobile/di/di.dart' as di;
import 'package:uskudar_mobile/domain/enums/app_environment.dart';
import 'package:uskudar_mobile/preview_app.dart';

Future<void> main() async {
  const servicesConfigured = bool.fromEnvironment('USKUDAR_SERVICES_CONFIGURED');
  if (!servicesConfigured) {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const PreviewApp());
    return;
  }

  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initializeRequirements();
    await _runApplication();
  }, LogHelper.logCriticalError);
}

Future<void> _initializeRequirements() async {
  _setThemeMode();
  unawaited(_configureOrientation());
  unawaited(SystemChannels.textInput.invokeMethod('TextInput.hide'));

  const useProduction = String.fromEnvironment('APP_ENV') == 'production';
  const appEnvironment = useProduction || kReleaseMode
      ? AppEnvironment.production
      : kDebugMode
      ? AppEnvironment.development
      : AppEnvironment.test;

  await Future.wait([
    EnvironmentConfig.initialize(appEnvironment),
    EasyLocalization.ensureInitialized(),
    Firebase.initializeApp(),
  ]);

  await di.setupCritical();
  await _setupHiveAsync();
  await di.setupNonCritical();
  EasyLocalization.logger.enableBuildModes = [];
}

Future<void> _configureOrientation() async {
  const supportedOrientations = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];
  await SystemChrome.setPreferredOrientations(supportedOrientations);
}

void _setThemeMode() {
  // final brightness =
  //     WidgetsBinding.instance.platformDispatcher.platformBrightness;
  // final themeMode =
  //     brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

  // if (themeMode == ThemeMode.light) {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  // } else {
  //   SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(
  //       statusBarBrightness: Brightness.dark,
  //       statusBarIconBrightness: Brightness.light,
  //     ),
  //   );
  // }
}

Future<void> _setupHiveAsync() async {
  final directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);

  Hive
    ..registerAdapter(AuthTokenModelAdapter())
    ..registerAdapter(LoggedInModelAdapter())
    ..registerAdapter(NotificationItemModelAdapter());

  await Future.wait([
    _openBoxSafely(HiveBoxes.app),
    _openBoxSafely(HiveBoxes.auth),
    _openBoxSafely(HiveBoxes.notification),
  ]);
}

Future<Box<dynamic>> _openBoxSafely(String boxName) async {
  try {
    return await Hive.openBox<dynamic>(boxName);
  } catch (e, st) {
    if (e is! HiveError) rethrow;

    LogHelper.log(
      LogLevel.warning,
      'Hive box açılırken hata oluştu ($boxName): $e. Box temizleniyor...',
      stackTrace: st,
    );
    try {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box<dynamic>(boxName).close();
      }
      await Hive.deleteBoxFromDisk(boxName);
    } on Exception catch (deleteError, deleteSt) {
      LogHelper.log(
        LogLevel.warning,
        'Hive box silinirken hata oluştu ($boxName): $deleteError',
        stackTrace: deleteSt,
      );
    }
    return Hive.openBox<dynamic>(boxName);
  }
}

Future<void> _runApplication() async {
  Locale? savedLocale;
  try {
    final appLocalDataSource = di.getIt<AppLocalDataSource>();
    final savedLanguage = await appLocalDataSource.getSelectedLanguage();
    if (savedLanguage != null) {
      savedLocale = Locale(savedLanguage);
    }
  } on Exception catch (e) {
    LogHelper.log(LogLevel.error, 'Dil yüklenirken hata oluştu: $e');
  }

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationConstants.supportedLocales,
      path: LocalizationConstants.path,
      fallbackLocale: LocalizationConstants.fallbackLocale,
      startLocale: savedLocale ?? LocalizationConstants.fallbackLocale,
      useOnlyLangCode: true,
      child: const App(),
    ),
  );
}
