import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/metropol_transaction_list_params.dart';

part 'metropol_transaction_list_request.g.dart';

@JsonSerializable(createFactory: false)
final class MetropolTransactionListRequest
    extends MetropolTransactionListParams {
  const MetropolTransactionListRequest({
    required super.startDate,
    required super.endDate,
  });

  factory MetropolTransactionListRequest.fromParams(
    MetropolTransactionListParams params,
  ) {
    return MetropolTransactionListRequest(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }

  Map<String, dynamic> toJson() =>
      _$MetropolTransactionListRequestToJson(this);
}
