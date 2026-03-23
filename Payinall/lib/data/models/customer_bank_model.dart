import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/customer_bank_response.dart';
import 'package:payinall/domain/entities/customer_bank.dart';

final class CustomerBankModel extends CustomerBank {
  const CustomerBankModel({
    required super.bankId,
    required super.bankName,
    required super.iban,
    required super.title,
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
    );
  }
}
