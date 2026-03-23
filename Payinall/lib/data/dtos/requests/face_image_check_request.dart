import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/face_image_check_params.dart';

part 'face_image_check_request.g.dart';

@JsonSerializable(createFactory: false)
final class FaceImageCheckRequest extends FaceImageCheckParams {
  const FaceImageCheckRequest({
    required super.processId,
    required super.faceImage,
    required super.faceImageList,
    super.thresholdOption = 0,
  });

  factory FaceImageCheckRequest.fromParams(FaceImageCheckParams params) {
    return FaceImageCheckRequest(
      processId: params.processId,
      faceImage: params.faceImage,
      faceImageList: params.faceImageList,
      thresholdOption: params.thresholdOption,
    );
  }

  Map<String, dynamic> toJson() => _$FaceImageCheckRequestToJson(this);
}
