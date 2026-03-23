import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/transactions_params.dart';

part 'transactions_request.g.dart';

@JsonSerializable(createFactory: false)
final class TransactionsRequest extends TransactionsParams {
  const TransactionsRequest({
    required super.startDate,
    required super.endDate,
    required super.transferOperationType,
  });

  factory TransactionsRequest.fromParams(TransactionsParams params) {
    return TransactionsRequest(
      startDate: params.startDate,
      endDate: params.endDate,
      transferOperationType: params.transferOperationType,
    );
  }

  Map<String, dynamic> toJson() => _$TransactionsRequestToJson(this);
}
