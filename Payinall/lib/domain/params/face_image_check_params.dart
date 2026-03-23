class FaceImageCheckParams {
  const FaceImageCheckParams({
    required this.processId,
    required this.faceImage,
    required this.faceImageList,
    this.thresholdOption = 0,
  });

  final String processId;
  final int thresholdOption;
  final String? faceImage;
  final List<String> faceImageList;
}
