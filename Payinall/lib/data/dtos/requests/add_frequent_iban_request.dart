import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/add_frequent_iban_params.dart';

part 'add_frequent_iban_request.g.dart';

@JsonSerializable(createFactory: false)
final class AddFrequentIbanRequest extends AddFrequentIbanParams {
  const AddFrequentIbanRequest({
    required super.ibanNo,
    required super.firstName,
    required super.lastName,
  });

  factory AddFrequentIbanRequest.fromParams(AddFrequentIbanParams params) {
    return AddFrequentIbanRequest(
      ibanNo: params.ibanNo,
      firstName: params.firstName,
      lastName: params.lastName,
    );
  }

  Map<String, dynamic> toJson() => _$AddFrequentIbanRequestToJson(this);
}
