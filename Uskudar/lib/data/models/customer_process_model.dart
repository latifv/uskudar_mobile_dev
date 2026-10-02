import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/customer_process_response.dart';
import 'package:uskudar_mobile/domain/entities/customer_process.dart';

final class CustomerProcessModel extends CustomerProcess {
  const CustomerProcessModel({
    required super.timeInfo,
    required super.onlyTransferLimit,
    required super.processName,
    required super.remainingNumberOfTransactions,
    required super.remainingAmountOfMoney,
  });
  factory CustomerProcessModel.fromResponse(CustomerProcessResponse response) {
    if (response.timeInfo == null ||
        response.onlyTransferLimit == null ||
        response.processName == null ||
        response.remainingNumberOfTransactions == null ||
        response.remainingAmountOfMoney == null) {
      throw const MappingException();
    }

    return CustomerProcessModel(
      timeInfo: response.timeInfo!,
      onlyTransferLimit: response.onlyTransferLimit!,
      processName: response.processName!,
      remainingNumberOfTransactions: response.remainingNumberOfTransactions!,
      remainingAmountOfMoney: response.remainingAmountOfMoney!,
    );
  }
}
