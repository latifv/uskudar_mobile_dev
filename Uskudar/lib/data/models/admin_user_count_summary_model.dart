import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/admin_user_count_response.dart';
import 'package:payinall/domain/entities/admin_user_count_summary.dart';

final class AdminUserCountSummaryModel extends AdminUserCountSummary {
  const AdminUserCountSummaryModel({
    required super.count,
    required super.timeTypeDescription,
  });

  factory AdminUserCountSummaryModel.fromResponse(
    AdminUserCountResponse response,
  ) {
    if (response.item1 == null || response.item2 == null) {
      throw const MappingException();
    }

    return AdminUserCountSummaryModel(
      count: response.item1!,
      timeTypeDescription: response.item2!,
    );
  }
}
