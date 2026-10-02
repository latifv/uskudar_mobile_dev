import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/data/dtos/responses/sector_array_response.dart';

part 'merchant_response.g.dart';

@JsonSerializable(createToJson: false)
final class MerchantResponse {
  const MerchantResponse({
    this.id,
    this.name,
    this.type,
    this.sectorArr,
    this.logo,
    this.sectorArray,
  });

  factory MerchantResponse.fromJson(Map<String, dynamic> json) =>
      _$MerchantResponseFromJson(json);

  final int? id;
  final String? name;
  @JsonKey(name: '_type')
  final String? type;
  @JsonKey(name: 'sector_arr')
  final List<String>? sectorArr;
  final String? logo;
  @JsonKey(name: 'sector_array')
  final List<SectorArrayResponse>? sectorArray;
}
