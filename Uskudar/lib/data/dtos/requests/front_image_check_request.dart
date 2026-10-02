import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/front_image_check_params.dart';

part 'front_image_check_request.g.dart';

@JsonSerializable(createFactory: false)
final class FrontImageCheckRequest extends FrontImageCheckParams {
  const FrontImageCheckRequest({required super.image});

  factory FrontImageCheckRequest.fromParams(FrontImageCheckParams params) {
    return FrontImageCheckRequest(image: params.image);
  }

  Map<String, dynamic> toJson() => _$FrontImageCheckRequestToJson(this);
}
