import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/app_bank_response.dart';
import 'package:uskudar_mobile/domain/entities/app_bank.dart';

final class AppBankModel extends AppBank {
  AppBankModel({
    required super.id,
    required super.bankId,
    required super.bankName,
    required super.iban,
    required super.order,
    required super.isActive,
  });

  factory AppBankModel.fromResponse(AppBankResponse response) {
    if (response.id == null ||
        response.bankId == null ||
        response.bankName == null ||
        response.iban == null ||
        response.order == null ||
        response.isActive == null) {
      throw const MappingException();
    }

    return AppBankModel(
      id: response.id!,
      bankId: response.bankId!,
      bankName: response.bankName!,
      iban: response.iban!,
      order: response.order!,
      isActive: response.isActive!,
    );
  }
}
