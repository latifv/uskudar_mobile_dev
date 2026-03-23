import 'dart:async';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/presentation/pages/qr_operation/display/bloc/qr_display_bloc.dart';

mixin QrDisplayMixin<T extends StatefulWidget> on State<T> {
  late final QrDisplayBloc bloc;

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void onLoadQrData({required Uint8List qrImage, required double amount}) {
    bloc.add(QrDisplayLoadData(qrImage: qrImage, amount: amount));
  }

  void onClosePressed() {
    context.router.pop();
  }
}
