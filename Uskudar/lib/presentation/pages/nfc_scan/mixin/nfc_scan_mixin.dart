import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uskudar_mobile/core/constants/app_constants.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/entities/nfc_identity.dart';
import 'package:uskudar_mobile/presentation/pages/nfc_scan/bloc/nfc_scan_bloc.dart';

mixin NfcScanMixin<T extends StatefulWidget> on State<T> {
  late final NfcScanBloc bloc;
  static final methodChannel = MethodChannel(AppConstants.arkSignerLiveAuth);
  dynamic nfcScanResult;
  late final String processId;
  late final String mrz;

  @override
  void initState() {
    super.initState();
    bloc = getIt<NfcScanBloc>();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  Future<void> onNfcScanStart() async {
    try {
      bloc.add(const NfcScanStart());

      nfcScanResult = await methodChannel.invokeMethod('nfc');

      if (nfcScanResult is Map<dynamic, dynamic>) {
        final nfcData = NfcIdentity.fromMap(
          nfcScanResult as Map<dynamic, dynamic>,
        );
        bloc.add(NfcScanEnd(processId: processId, nfcData: nfcData, mrz: mrz));
      } else {
        bloc.add(NfcScanEnd(processId: processId, nfcData: null, mrz: mrz));
      }
    } on PlatformException {
      bloc.add(NfcScanEnd(processId: processId, nfcData: null, mrz: mrz));
    } on Exception {
      bloc.add(NfcScanEnd(processId: processId, nfcData: null, mrz: mrz));
    }
  }
}
