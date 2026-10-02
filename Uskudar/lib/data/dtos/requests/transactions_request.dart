import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/transactions_params.dart';

part 'transactions_request.g.dart';

@JsonSerializable(createFactory: false)
final class TransactionsRequest extends TransactionsParams {
  const TransactionsRequest({
    required super.startDate,
    required super.endDate,
    required super.transferOperationType,
    required super.pageNumber,
    required super.pageSize,
  });

  factory TransactionsRequest.fromParams(TransactionsParams params) {
    return TransactionsRequest(
      startDate: params.startDate,
      endDate: params.endDate,
      transferOperationType: params.transferOperationType,
      pageNumber: params.pageNumber,
      pageSize: params.pageSize,
    );
  }

  Map<String, dynamic> toJson() => _$TransactionsRequestToJson(this);
}
