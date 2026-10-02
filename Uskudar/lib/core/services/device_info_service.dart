import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/utils/log_level.dart';

abstract interface class DeviceInfoService {
  Future<String?> getDeviceId();
  Future<int> getAndroidSdkInt();
  Future<String> getIOSVersion();
}

final class DeviceInfoServiceImpl implements DeviceInfoService {
  DeviceInfoServiceImpl() {
    _deviceInfoPlugin = DeviceInfoPlugin();
    _mobileDeviceIdentifier = MobileDeviceIdentifier();
  }

  late final DeviceInfoPlugin _deviceInfoPlugin;
  late final MobileDeviceIdentifier _mobileDeviceIdentifier;

  @override
  Future<String?> getDeviceId() async {
    try {
      final deviceId = await _mobileDeviceIdentifier.getDeviceId();
      LogHelper.log(LogLevel.debug, 'Device ID: $deviceId');
      if (deviceId == null) {
        if (Platform.isAndroid) {
          final androidDeviceId = await _getAndroidId();
          LogHelper.log(LogLevel.debug, 'Android ID: $androidDeviceId');
          return androidDeviceId;
        } else if (Platform.isIOS) {
          final iosDeviceId = await _getIOSId();
          LogHelper.log(LogLevel.debug, 'IOS ID: $iosDeviceId');
          return iosDeviceId;
        }
      }
      return deviceId;
    } on Exception catch (e) {
      LogHelper.log(LogLevel.warning, 'Device ID alınamadı: $e');
      try {
        if (Platform.isAndroid) {
          return await _getAndroidId();
        } else if (Platform.isIOS) {
          return await _getIOSId();
        }
      } on Exception catch (e) {
        LogHelper.log(LogLevel.warning, 'Fallback Device ID alınamadı: $e');
      }
      return null;
    }
  }

  Future<String> _getAndroidId() async {
    final androidInfo = await _deviceInfoPlugin.androidInfo;
    return androidInfo.id;
  }

  Future<String?> _getIOSId() async {
    final iosInfo = await _deviceInfoPlugin.iosInfo;
    return iosInfo.identifierForVendor;
  }

  @override
  Future<int> getAndroidSdkInt() async {
    final androidInfo = await _deviceInfoPlugin.androidInfo;
    return androidInfo.version.sdkInt;
  }

  @override
  Future<String> getIOSVersion() async {
    final iosInfo = await _deviceInfoPlugin.iosInfo;
    return iosInfo.systemVersion;
  }
}
