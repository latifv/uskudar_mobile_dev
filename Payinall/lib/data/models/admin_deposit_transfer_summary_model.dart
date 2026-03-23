import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/admin_deposit_transfer_summary_response.dart';
import 'package:payinall/domain/entities/admin_deposit_transfer_summary.dart';

final class AdminDepositTransferSummaryModel
    extends AdminDepositTransferSummary {
  const AdminDepositTransferSummaryModel({
    required super.amount,
    required super.timeTypeDescription,
  });

  factory AdminDepositTransferSummaryModel.fromResponse(
    AdminDepositTransferSummaryResponse response,
  ) {
    if (response.item1 == null || response.item2 == null) {
      throw const MappingException();
    }

    return AdminDepositTransferSummaryModel(
      amount: response.item1!,
      timeTypeDescription: response.item2!,
    );
  }
}
