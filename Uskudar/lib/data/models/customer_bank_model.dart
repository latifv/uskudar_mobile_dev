import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/customer_bank_response.dart';
import 'package:uskudar_mobile/domain/entities/customer_bank.dart';

final class CustomerBankModel extends CustomerBank {
  const CustomerBankModel({
    required super.bankId,
    required super.bankName,
    required super.iban,
    required super.title,
    required super.isOwnerIban,
  });

  factory CustomerBankModel.fromResponse(CustomerBankResponse response) {
    if (response.bankId == null ||
        response.bankName == null ||
        response.iban == null ||
        response.title == null) {
      throw const MappingException();
    }

    return CustomerBankModel(
      bankId: response.bankId!,
      bankName: response.bankName!,
      iban: response.iban!,
      title: response.title!,
      isOwnerIban: response.isOwnerIban ?? false,
    );
  }
}
