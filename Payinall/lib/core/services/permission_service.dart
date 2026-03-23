import 'dart:io';

import 'package:payinall/core/services/device_info_service.dart';
import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/utils/log_level.dart';
import 'package:permission_handler/permission_handler.dart';

abstract interface class PermissionService {
  Future<bool> hasCameraPermission();
  Future<bool> hasGalleryPermission();
  Future<void> requestCameraPermission();
  Future<void> requestGalleryPermission();
  Future<void> requestMicrophonePermission();
  Future<bool> hasMicrophonePermission();
  Future<bool> hasContactsPermission();
  Future<bool> requestContactsPermission();
  Future<bool> hasLimitedContactsPermission();
  Future<bool> openAppSettings();
}

final class PermissionServiceImpl implements PermissionService {
  PermissionServiceImpl({required this.deviceInfoService});

  final DeviceInfoService deviceInfoService;

  @override
  Future<bool> hasCameraPermission() async {
    final hasCameraPermission = await _isCameraPermissionGranted();
    return hasCameraPermission;
  }

  @override
  Future<bool> hasGalleryPermission() async {
    final hasGalleryPermission = await _isGalleryPermissionGranted();
    return hasGalleryPermission;
  }

  @override
  Future<void> requestCameraPermission() async {
    LogHelper.log(LogLevel.debug, 'Kamera izni isteniyor');
    if (Platform.isAndroid) {
      const permission = Permission.camera;
      final before = await permission.shouldShowRequestRationale;
      final rs = await permission.request();
      final after = await permission.shouldShowRequestRationale;
      LogHelper.log(LogLevel.debug, 'Kamera izni sonuç: $rs');
      if (!rs.isGranted && !before && !after) {
        await openAppSettings();
      }
    } else if (Platform.isIOS) {
      final result = await Permission.camera.status;
      LogHelper.log(LogLevel.debug, 'Kamera izni durumu: $result');
      if (result.isDenied) {
        LogHelper.log(LogLevel.debug, 'Kamera izni reddedildi');
        await Permission.camera.request();
      } else if (result.isPermanentlyDenied) {
        LogHelper.log(LogLevel.debug, 'Kamera izni kalıcı olarak reddedildi');
        await openAppSettings();
      }
    }
  }

  @override
  Future<void> requestGalleryPermission() async {
    LogHelper.log(LogLevel.debug, 'Galeri izni isteniyor');
    if (Platform.isAndroid) {
      final permission = await _getAndroidGalleryPermissionType();
      final before = await permission.shouldShowRequestRationale;
      final rs = await permission.request();
      final after = await permission.shouldShowRequestRationale;
      LogHelper.log(LogLevel.debug, 'Galeri izni sonuç: $rs');
      if (!rs.isGranted && !before && !after) {
        await openAppSettings();
      }
    } else if (Platform.isIOS) {
      final result = await Permission.photos.status;
      LogHelper.log(LogLevel.debug, 'Galeri izni durumu: $result');
      if (result.isDenied) {
        LogHelper.log(LogLevel.debug, 'Galeri izni reddedildi');
        await Permission.photos.request();
      } else if (result.isPermanentlyDenied) {
        LogHelper.log(LogLevel.debug, 'Galeri izni kalıcı olarak reddedildi');
        await openAppSettings();
      }
    }
  }

  Future<bool> _isGalleryPermissionGranted() async {
    late final PermissionStatus status;
    if (Platform.isAndroid) {
      final permission = await _getAndroidGalleryPermissionType();
      status = await permission.status;
    } else if (Platform.isIOS) {
      status = await Permission.photos.status;
    }
    return status.isGranted;
  }

  Future<bool> _isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  Future<Permission> _getAndroidGalleryPermissionType() async {
    final sdkInt = await deviceInfoService.getAndroidSdkInt();
    late final Permission permission;
    if (sdkInt <= 32) {
      permission = Permission.storage;
    } else {
      permission = Permission.photos;
    }
    return permission;
  }

  @override
  Future<bool> hasMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  @override
  Future<void> requestMicrophonePermission() async {
    LogHelper.log(LogLevel.debug, 'Mikrofon izni isteniyor');
    final status = await Permission.microphone.status;
    LogHelper.log(LogLevel.debug, 'Mikrofon izni durumu: $status');
    if (status.isDenied) {
      LogHelper.log(LogLevel.debug, 'Mikrofon izni reddedildi');
      await Permission.microphone.request();
    } else if (status.isPermanentlyDenied) {
      LogHelper.log(LogLevel.debug, 'Mikrofon izni kalıcı olarak reddedildi');
      await openAppSettings();
    }
  }

  @override
  Future<bool> hasContactsPermission() async {
    final status = await Permission.contacts.status;
    return status.isGranted || status.isLimited;
  }

  @override
  Future<bool> requestContactsPermission() async {
    LogHelper.log(LogLevel.debug, 'Rehber izni isteniyor');
    final status = await Permission.contacts.status;
    LogHelper.log(LogLevel.debug, 'Rehber izni durumu: $status');

    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (status.isDenied) {
      LogHelper.log(LogLevel.debug, 'Rehber izni reddedildi, izin isteniyor');
      final result = await Permission.contacts.request();
      LogHelper.log(LogLevel.debug, 'Rehber izni sonuç: $result');
      return result.isGranted || result.isLimited;
    }

    if (status.isPermanentlyDenied) {
      LogHelper.log(LogLevel.debug, 'Rehber izni kalıcı olarak reddedildi');
      await openAppSettings();
      return false;
    }

    return false;
  }

  @override
  Future<bool> hasLimitedContactsPermission() async {
    final status = await Permission.contacts.status;
    return status.isLimited;
  }

  @override
  Future<bool> openAppSettings() async {
    LogHelper.log(LogLevel.debug, 'Uygulama ayarları açılıyor');
    return openAppSettings();
  }
}
