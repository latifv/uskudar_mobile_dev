import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uskudar_mobile/core/constants/app_constants.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/back_id_scan/bloc/back_id_scan_bloc.dart';

mixin BackIdScanMixin<T extends StatefulWidget> on State<T> {
  late final BackIdScanBloc bloc;
  static final methodChannel = MethodChannel(AppConstants.arkSignerLiveAuth);
  dynamic backIdScanResult;
  late final String processId;
  String? mrz;
  @override
  void initState() {
    super.initState();
    bloc = getIt<BackIdScanBloc>();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  Future<void> onBackIdScanStart() async {
    try {
      bloc.add(const BackIdScanStart());

      backIdScanResult = await methodChannel.invokeMethod('backside');

      if (backIdScanResult is Map<dynamic, dynamic> &&
          (backIdScanResult as Map<dynamic, dynamic>).containsKey('image')) {
        final image =
            (backIdScanResult as Map<dynamic, dynamic>)['image'] as String?;
        mrz =
            (backIdScanResult as Map<dynamic, dynamic>)['mrzString'] as String?;

        bloc.add(BackIdScanEnd(processId: processId, image: image));
      } else {
        bloc.add(BackIdScanEnd(processId: processId, image: ''));
      }
    } on PlatformException {
      bloc.add(BackIdScanEnd(processId: processId, image: ''));
    } on Exception {
      bloc.add(BackIdScanEnd(processId: processId, image: ''));
    }
  }
}
