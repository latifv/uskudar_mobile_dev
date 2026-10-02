import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/app_inherited_widget.dart';
import 'package:uskudar_mobile/core/constants/app_constants.dart';
import 'package:uskudar_mobile/core/constants/localization_constants.dart';
import 'package:uskudar_mobile/core/managers/signalr_manager.dart';
import 'package:uskudar_mobile/core/services/firebase_service.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';
import 'package:uskudar_mobile/core/utils/log_level.dart';
import 'package:uskudar_mobile/data/datasources/local/app_local_data_source.dart';
import 'package:uskudar_mobile/di/di.dart' as di;
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/theme/app_theme.dart';

final class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

final class _AppState extends State<App> with WidgetsBindingObserver {
  late final SignalRManager _signalRManager;
  late final FirebaseService _firebaseService;
  late final AppLocalDataSource _appLocalDataSource;
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _signalRManager = di.getIt<SignalRManager>();
    _firebaseService = di.getIt<FirebaseService>();
    _appLocalDataSource = di.getIt<AppLocalDataSource>();
    unawaited(_loadThemeMode());
    unawaited(_initializeLocale());
  }

  Future<void> _initializeLocale() async {
    await _ensureSavedLocale();
  }

  Future<void> _loadThemeMode() async {
    final isDarkMode = await _appLocalDataSource.getIsDarkMode();
    if (mounted) {
      setState(() {
        _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      });
    }
  }

  void updateThemeMode(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
    unawaited(_appLocalDataSource.setIsDarkMode(isDarkMode));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    LogHelper.log(LogLevel.info, 'Uygulama yaşam döngüsü değişti: $state');

    switch (state) {
      case AppLifecycleState.resumed:
        LogHelper.log(
          LogLevel.info,
          'Uygulama ön plana geçti - SignalR durumu kontrol ediliyor',
        );
        unawaited(_signalRManager.initializeAndConnect());
      case AppLifecycleState.paused:
        // LogHelper.log(
        //   LogLevel.info,
        //   'Uygulama arka plana geçti - SignalR bağlantısı kesiliyor',
        // );
        // unawaited(_signalRManager.disconnect());
        break;
      case AppLifecycleState.detached:
        LogHelper.log(
          LogLevel.info,
          'Uygulama kapanıyor - kaynaklar temizleniyor',
        );
        unawaited(_signalRManager.disconnect());
        unawaited(_disposeResources());
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    LogHelper.log(
      LogLevel.info,
      'Sistem lokalizasyon değişikliği algılandı: $locales',
    );
    unawaited(_handleLocaleChange(locales));
  }

  Future<void> _handleLocaleChange(List<Locale>? systemLocales) async {
    try {
      final savedLanguage = await _appLocalDataSource.getSelectedLanguage();

      if (savedLanguage != null && mounted) {
        final savedLocale = Locale(savedLanguage);
        final currentLocale = context.locale;

        if (currentLocale.languageCode != savedLocale.languageCode) {
          LogHelper.log(
            LogLevel.info,
            'Kaydedilmiş dil ($savedLanguage) uygulanıyor',
          );
          unawaited(context.setLocale(savedLocale));
        }
      } else if (systemLocales != null && systemLocales.isNotEmpty && mounted) {
        final systemLocale = systemLocales.first;
        final supportedLocale = _getSupportedLocale(systemLocale);
        final currentLocale = context.locale;

        if (currentLocale.languageCode != supportedLocale.languageCode) {
          LogHelper.log(
            LogLevel.info,
            'Kaydedilmiş dil yok, sistem dili (${supportedLocale.languageCode}) kaydediliyor ve uygulanıyor',
          );
          await _appLocalDataSource.setSelectedLanguage(
            supportedLocale.languageCode,
          );
          if (mounted) {
            unawaited(context.setLocale(supportedLocale));
          }
        }
      }
    } on Exception catch (e) {
      LogHelper.log(
        LogLevel.error,
        'Dil değişikliği işlenirken hata oluştu: $e',
      );
    }
  }

  Future<void> _ensureSavedLocale() async {
    try {
      final savedLanguage = await _appLocalDataSource.getSelectedLanguage();

      if (savedLanguage != null && mounted) {
        final savedLocale = Locale(savedLanguage);
        final currentLocale = context.locale;

        if (currentLocale.languageCode != savedLocale.languageCode) {
          LogHelper.log(
            LogLevel.info,
            'Kaydedilmiş dil ($savedLanguage) uygulanıyor',
          );
          unawaited(context.setLocale(savedLocale));
        }
      } else if (mounted) {
        final currentLocale = context.locale;
        final supportedLocale = _getSupportedLocale(currentLocale);

        LogHelper.log(
          LogLevel.info,
          'Kaydedilmiş dil yok, mevcut dil (${supportedLocale.languageCode}) kaydediliyor',
        );
        await _appLocalDataSource.setSelectedLanguage(
          supportedLocale.languageCode,
        );
      }
    } on Exception catch (e) {
      LogHelper.log(
        LogLevel.error,
        'Kaydedilmiş dil kontrol edilirken hata oluştu: $e',
      );
    }
  }

  Future<void> _updateLocale(Locale locale) async {
    if (!mounted) return;
    await _appLocalDataSource.setSelectedLanguage(locale.languageCode);
    if (mounted) {
      unawaited(context.setLocale(locale));
    }
  }

  Locale _getSupportedLocale(Locale locale) {
    final supportedLocales = context.supportedLocales;
    final matchingLocale = supportedLocales.firstWhere(
      (supported) => supported.languageCode == locale.languageCode,
      orElse: () => LocalizationConstants.fallbackLocale,
    );
    return matchingLocale;
  }

  Future<void> _disposeResources() async {
    try {
      await di.disposeDI();
    } on Exception catch (e) {
      LogHelper.log(LogLevel.error, 'Kaynaklar temizlenirken hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppInheritedWidget(
      updateThemeMode: updateThemeMode,
      updateLocale: _updateLocale,
      child: MaterialApp.router(
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (_) => AppConstants.appName,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        routerConfig: di.getIt<AppRouter>().config(
          deepLinkBuilder: (deepLink) {
            return deepLink;
          },
          navigatorObservers: () {
            final observer = _firebaseService.getAnalyticsObserver();
            return observer == null ? [] : [observer];
          },
        ),
        theme: AppTheme.light().data,
        darkTheme: AppTheme.dark().data,
        themeMode: _themeMode,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
              platformBrightness: MediaQuery.of(context).platformBrightness,
              alwaysUse24HourFormat: true,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
