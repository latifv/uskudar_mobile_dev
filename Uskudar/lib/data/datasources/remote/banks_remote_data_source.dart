// import 'package:payinall/core/error/exceptions.dart';
// import 'package:payinall/data/core/base_remote_data_source.dart';
// import 'package:payinall/data/dtos/responses/bank_response.dart';
// import 'package:payinall/data/models/bank_model.dart';
// import 'package:payinall/data/network/config/endpoints.dart';
// import 'package:payinall/data/network/models/network_response.dart';

// abstract interface class BanksRemoteDataSource {
//   Future<NetworkResponse<List<BankModel>>> getList();
//   Future<NetworkResponse<BankModel>> getById(String id);
// }

// final class BanksRemoteDataSourceImpl extends BaseRemoteDataSource
//     implements BanksRemoteDataSource {
//   BanksRemoteDataSourceImpl(super.networkClient);

//   @override
//   Future<NetworkResponse<List<BankModel>>> getList() async {
//     final responseJson = await get(endpoint: Endpoints.banksGetList);
//     final response = NetworkResponse.fromJson<List<BankResponse>>(
//       responseJson,
//       fromJsonT: (json) {
//         if (json is Map<String, dynamic>) {
//           return (json['data'] as List)
//               .map(
//                 (item) => BankResponse.fromJson(item as Map<String, dynamic>),
//               )
//               .toList();
//         }
//         throw const MappingException();
//       },
//     );
//     return response.map(
//       (responseList) => responseList.map(BankModel.fromResponse).toList(),
//     );
//   }

//   @override
//   Future<NetworkResponse<BankModel>> getById(String id) async {
//     final responseJson = await get(endpoint: Endpoints.banksGetById(id));
//     final response = NetworkResponse.fromJson<BankResponse>(responseJson);
//     return response.map(BankModel.fromResponse);
//   }
// }
