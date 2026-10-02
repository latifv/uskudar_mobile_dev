part of 'face_scan_bloc.dart';

sealed class FaceScanEvent {
  const FaceScanEvent();
}

final class FaceScanAgreementsCompleted extends FaceScanEvent {
  const FaceScanAgreementsCompleted();
}

final class FaceScanStart extends FaceScanEvent {
  const FaceScanStart();
}

final class FaceScanEnd extends FaceScanEvent {
  const FaceScanEnd({
    required this.faceImageList,
    required this.processId,
    required this.image,
  });

  final String processId;
  final List<String> faceImageList;
  final String? image;
}
