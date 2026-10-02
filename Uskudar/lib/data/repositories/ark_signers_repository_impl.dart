import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/ark_signers_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/back_image_check_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/face_image_check_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/front_image_check_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/nfc_check_request.dart';
import 'package:uskudar_mobile/data/models/nfc_model.dart';
import 'package:uskudar_mobile/domain/entities/nfc.dart';
import 'package:uskudar_mobile/domain/params/back_image_check_params.dart';
import 'package:uskudar_mobile/domain/params/face_image_check_params.dart';
import 'package:uskudar_mobile/domain/params/front_image_check_params.dart';
import 'package:uskudar_mobile/domain/params/nfc_check_params.dart';
import 'package:uskudar_mobile/domain/repositories/ark_signers_repository.dart';

final class ArkSignersRepositoryImpl implements ArkSignersRepository {
  ArkSignersRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final ArkSignersRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, String>> frontImageCheck(
    FrontImageCheckParams params,
  ) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final request = FrontImageCheckRequest.fromParams(params);
        final result = await remoteDataSource.frontImageCheck(request);
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, void>> backImageCheck(
    BackImageCheckParams params,
  ) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final request = BackImageCheckRequest.fromParams(params);
        final result = await remoteDataSource.backImageCheck(request);
        return result;
      },
      onlyResponseType: true,
    );
  }

  @override
  Future<Either<Failure, void>> faceImageCheck(
    FaceImageCheckParams params,
  ) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final request = FaceImageCheckRequest.fromParams(params);
        final result = await remoteDataSource.faceImageCheck(request);
        return result;
      },
      onlyResponseType: true,
    );
  }

  @override
  Future<Either<Failure, Nfc>> nfcCheck(NfcCheckParams params) async {
    return _dataSourceHandler.handle<Nfc, NfcModel>(
      remoteFunction: () async {
        final request = NfcCheckRequest.fromParams(params);
        final result = await remoteDataSource.nfcCheck(request);
        return result;
      },
      onlyData: true,
    );
  }
}
