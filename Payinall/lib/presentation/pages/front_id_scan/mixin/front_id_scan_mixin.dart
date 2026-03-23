import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payinall/core/constants/app_constants.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/front_id_scan/bloc/front_id_scan_bloc.dart';

mixin FrontIdScanMixin<T extends StatefulWidget> on State<T> {
  late final FrontIdScanBloc bloc;
  static final methodChannel = MethodChannel(AppConstants.arkSignerLiveAuth);
  dynamic frontIdScanResult;
  @override
  void initState() {
    super.initState();
    bloc = getIt<FrontIdScanBloc>();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  Future<void> onFrontIdScanStart() async {
    try {
      bloc.add(const FrontIdScanStart());

      frontIdScanResult = await methodChannel.invokeMethod('frontside');

      if (frontIdScanResult is Map<dynamic, dynamic> &&
          (frontIdScanResult as Map<dynamic, dynamic>).containsKey('image')) {
        final image =
            (frontIdScanResult as Map<dynamic, dynamic>)['image'] as String?;
        bloc.add(FrontIdScanEnd(image: image));
      } else {
        bloc.add(const FrontIdScanEnd(image: ''));
      }
    } on PlatformException {
      bloc.add(const FrontIdScanEnd(image: ''));
    } on Exception {
      bloc.add(const FrontIdScanEnd(image: ''));
    }
  }
}
