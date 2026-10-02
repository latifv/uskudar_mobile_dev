// import 'package:payinall/core/error/exceptions.dart';
// import 'package:payinall/data/dtos/responses/bank_response.dart';
// import 'package:payinall/domain/entities/bank.dart';

// final class BankModel extends Bank {
//   const BankModel({
//     required super.id,
//     required super.code,
//     required super.name,
//     required super.fullName,
//     required super.createdOn,
//   });

//   factory BankModel.fromResponse(BankResponse response) {
//     if (response.id == null ||
//         response.code == null ||
//         response.name == null ||
//         response.fullName == null ||
//         response.createdOn == null) {
//       throw const MappingException();
//     }

//     return BankModel(
//       id: response.id!,
//       code: response.code!,
//       name: response.name!,
//       fullName: response.fullName!,
//       createdOn: response.createdOn!,
//     );
//   }
// }
