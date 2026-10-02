import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/back_image_check_params.dart';

part 'back_image_check_request.g.dart';

@JsonSerializable(createFactory: false)
final class BackImageCheckRequest extends BackImageCheckParams {
  const BackImageCheckRequest({required super.image, required super.processId});

  factory BackImageCheckRequest.fromParams(BackImageCheckParams params) {
    return BackImageCheckRequest(
      image: params.image,
      processId: params.processId,
    );
  }

  Map<String, dynamic> toJson() => _$BackImageCheckRequestToJson(this);
}
