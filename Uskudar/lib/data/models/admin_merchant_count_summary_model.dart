import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/admin_merchant_count_response.dart';
import 'package:payinall/domain/entities/admin_merchant_count_summary.dart';

final class AdminMerchantCountSummaryModel extends AdminMerchantCountSummary {
  const AdminMerchantCountSummaryModel({
    required super.count,
    required super.timeTypeDescription,
  });

  factory AdminMerchantCountSummaryModel.fromResponse(
    AdminMerchantCountResponse response,
  ) {
    if (response.item1 == null || response.item2 == null) {
      throw const MappingException();
    }

    return AdminMerchantCountSummaryModel(
      count: response.item1!,
      timeTypeDescription: response.item2!,
    );
  }
}
