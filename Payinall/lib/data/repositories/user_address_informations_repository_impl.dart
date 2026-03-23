import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/user_address_informations_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/address_number_inquiry_request.dart';
import 'package:payinall/data/dtos/requests/user_address_information_approve_request.dart';
import 'package:payinall/data/models/user_address_information_model.dart';
import 'package:payinall/domain/entities/user_address_information.dart';
import 'package:payinall/domain/params/address_number_inquiry_params.dart';
import 'package:payinall/domain/params/get_user_address_information_params.dart';
import 'package:payinall/domain/params/user_address_information_approve_params.dart';
import 'package:payinall/domain/repositories/user_address_informations_repository.dart';

final class UserAddressInformationsRepositoryImpl
    implements UserAddressInformationsRepository {
  UserAddressInformationsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final UserAddressInformationsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, void>> addressNumberInquiry(
    AddressNumberInquiryParams params,
  ) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final request = AddressNumberInquiryRequest.fromParams(params);
        final result = await remoteDataSource.addressNumberInquiry(request);
        return result;
      },
      onlyResponseType: true,
    );
  }

  @override
  Future<Either<Failure, UserAddressInformation>> getUserAddressInformation(
    GetUserAddressInformationParams params,
  ) async {
    return _dataSourceHandler
        .handle<UserAddressInformation, UserAddressInformationModel>(
          remoteFunction: () async {
            final result = await remoteDataSource.getUserAddressInformation();
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, void>> userAddressInformationApprove(
    UserAddressInformationApproveParams params,
  ) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final request = UserAddressInformationApproveRequest.fromParams(params);
        final result = await remoteDataSource.userAddressInformationApprove(
          request,
        );
        return result;
      },
      onlyResponseType: true,
    );
  }
}
