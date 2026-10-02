import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/admin_wallet_transfer_summary_response.dart';
import 'package:payinall/domain/entities/admin_wallet_transfer_summary.dart';

final class AdminWalletTransferSummaryModel extends AdminWalletTransferSummary {
  const AdminWalletTransferSummaryModel({
    required super.amount,
    required super.timeTypeDescription,
  });

  factory AdminWalletTransferSummaryModel.fromResponse(
    AdminWalletTransferSummaryResponse response,
  ) {
    if (response.item1 == null || response.item2 == null) {
      throw const MappingException();
    }

    return AdminWalletTransferSummaryModel(
      amount: response.item1!,
      timeTypeDescription: response.item2!,
    );
  }
}
