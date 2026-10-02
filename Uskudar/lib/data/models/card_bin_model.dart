import 'package:payinall/data/dtos/responses/card_bin_response.dart';
import 'package:payinall/domain/entities/card_bin.dart';

final class CardBinModel extends CardBin {
  const CardBinModel({
    required super.prefix,
  });

  factory CardBinModel.fromResponse(CardBinResponse response) => CardBinModel(
    prefix: response.prefix ?? '',
  );

  CardBin toEntity() => CardBin(
    prefix: prefix,
  );
}
