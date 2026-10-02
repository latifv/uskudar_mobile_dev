import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/admin_commission_summary_response.dart';
import 'package:uskudar_mobile/domain/entities/admin_commission_summary.dart';

final class AdminCommissionSummaryModel extends AdminCommissionSummary {
  const AdminCommissionSummaryModel({
    required super.amount,
    required super.timeTypeDescription,
  });

  factory AdminCommissionSummaryModel.fromResponse(
    AdminCommissionSummaryResponse response,
  ) {
    if (response.item1 == null || response.item2 == null) {
      throw const MappingException();
    }

    return AdminCommissionSummaryModel(
      amount: response.item1!,
      timeTypeDescription: response.item2!,
    );
  }
}
