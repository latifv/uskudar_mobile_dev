import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'qr_display_event.dart';
part 'qr_display_state.dart';

final class QrDisplayBloc extends Bloc<QrDisplayEvent, QrDisplayState> {
  QrDisplayBloc() : super(const QrDisplayInitial()) {
    on<QrDisplayLoadData>(_onLoadData);
  }

  Future<void> _onLoadData(
    QrDisplayLoadData event,
    Emitter<QrDisplayState> emit,
  ) async {
    emit(QrDisplayLoaded(qrImage: event.qrImage, amount: event.amount));
  }
}
