import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/admin_withdraw_transfer_summary_response.dart';
import 'package:uskudar_mobile/domain/entities/admin_withdraw_transfer_summary.dart';

final class AdminWithdrawTransferSummaryModel
    extends AdminWithdrawTransferSummary {
  const AdminWithdrawTransferSummaryModel({
    required super.amount,
    required super.timeTypeDescription,
  });

  factory AdminWithdrawTransferSummaryModel.fromResponse(
    AdminWithdrawTransferSummaryResponse response,
  ) {
    if (response.item1 == null || response.item2 == null) {
      throw const MappingException();
    }

    return AdminWithdrawTransferSummaryModel(
      amount: response.item1!,
      timeTypeDescription: response.item2!,
    );
  }
}
