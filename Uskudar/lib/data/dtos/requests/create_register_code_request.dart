import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/create_register_code_params.dart';

part 'create_register_code_request.g.dart';

@JsonSerializable(createFactory: false)
final class CreateRegisterCodeRequest extends CreateRegisterCodeParams {
  const CreateRegisterCodeRequest({required super.gsmNumber});

  factory CreateRegisterCodeRequest.fromParams(
    CreateRegisterCodeParams params,
  ) {
    return CreateRegisterCodeRequest(gsmNumber: params.gsmNumber);
  }

  Map<String, dynamic> toJson() => _$CreateRegisterCodeRequestToJson(this);
}
