// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'src/model/android_device_info.dart';
import 'src/model/ios_device_info.dart';

export 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart'
    show BaseDeviceInfo;

export 'src/model/android_device_info.dart';
export 'src/model/ios_device_info.dart';

/// Provides device and operating system information.
class DeviceInfoPlugin {
  /// No work is done when instantiating the plugin. It's safe to call this
  /// repeatedly or in performance-sensitive blocks.
  DeviceInfoPlugin();

  // This is to manually endorse the Linux plugin until automatic registration
  // of dart plugins is implemented.
  // See https://github.com/flutter/flutter/issues/52267 for more details.
  static DeviceInfoPlatform get _platform {
    return DeviceInfoPlatform.instance;
  }

  /// This information does not change from call to call. Cache it.
  AndroidDeviceInfo? _cachedAndroidDeviceInfo;

  /// Information derived from `android.os.Build`.
  ///
  /// See: https://developer.android.com/reference/android/os/Build.html
  Future<AndroidDeviceInfo> get androidInfo async =>
      _cachedAndroidDeviceInfo ??= AndroidDeviceInfo.fromMap(
        (await _platform.deviceInfo()).data,
      );

  /// This information does not change from call to call. Cache it.
  IosDeviceInfo? _cachedIosDeviceInfo;

  /// Information derived from `UIDevice`.
  ///
  /// See: https://developer.apple.com/documentation/uikit/uidevice
  Future<IosDeviceInfo> get iosInfo async => _cachedIosDeviceInfo ??=
      IosDeviceInfo.fromMap((await _platform.deviceInfo()).data);

  /// Returns device information for the current platform.
  Future<BaseDeviceInfo> get deviceInfo async {
    if (kIsWeb) {
      throw UnsupportedError('device_info_plus vendor package only supports iOS and Android.');
    }

    if (Platform.isAndroid) {
      return androidInfo;
    } else if (Platform.isIOS) {
      return iosInfo;
    }

    throw UnsupportedError('device_info_plus vendor package only supports iOS and Android.');
  }

  /// Initializes the application metadata with mock values for testing.
  @visibleForTesting
  static DeviceInfoPlugin setMockInitialValues({
    AndroidDeviceInfo? androidDeviceInfo,
    IosDeviceInfo? iosDeviceInfo,
  }) {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    deviceInfoPlugin._cachedAndroidDeviceInfo = androidDeviceInfo;
    deviceInfoPlugin._cachedIosDeviceInfo = iosDeviceInfo;
    return deviceInfoPlugin;
  }
}
