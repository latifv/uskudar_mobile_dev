import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/address_number_inquiry_params.dart';

part 'address_number_inquiry_request.g.dart';

@JsonSerializable(createFactory: false)
final class AddressNumberInquiryRequest extends AddressNumberInquiryParams {
  const AddressNumberInquiryRequest({required super.addressNumber});

  factory AddressNumberInquiryRequest.fromParams(
    AddressNumberInquiryParams params,
  ) {
    return AddressNumberInquiryRequest(addressNumber: params.addressNumber);
  }

  Map<String, dynamic> toJson() => _$AddressNumberInquiryRequestToJson(this);
}
