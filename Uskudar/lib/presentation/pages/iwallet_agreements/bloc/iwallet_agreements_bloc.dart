import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';
import 'package:uskudar_mobile/core/utils/log_level.dart';
import 'package:uskudar_mobile/domain/entities/iwallet_agreement.dart';
import 'package:uskudar_mobile/domain/usecases/get_iwallet_agreements_usecase.dart';

part 'iwallet_agreements_event.dart';
part 'iwallet_agreements_state.dart';

final class IWalletAgreementsBloc
    extends Bloc<IWalletAgreementsEvent, IWalletAgreementsState> {
  IWalletAgreementsBloc({
    required GetIWalletAgreementsUsecase getIWalletAgreementsUsecase,
  }) : _getIWalletAgreementsUsecase = getIWalletAgreementsUsecase,
       _dio = Dio(),
       super(const IWalletAgreementsState()) {
    on<GetIWalletAgreements>(_onGetIWalletAgreements);
    on<LoadAgreementHtml>(_onLoadAgreementHtml);
    on<AcceptCurrentAgreement>(_onAcceptCurrentAgreement);
  }

  final GetIWalletAgreementsUsecase _getIWalletAgreementsUsecase;
  final Dio _dio;

  Future<void> _onGetIWalletAgreements(
    GetIWalletAgreements event,
    Emitter<IWalletAgreementsState> emit,
  ) async {
    emit(state.copyWith(status: IWalletAgreementsStatus.loading));

    final result = await _getIWalletAgreementsUsecase(null);

    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: IWalletAgreementsStatus.error,
            message: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: IWalletAgreementsStatus.loaded,
            agreements: r,
            selectedIndex: 0,
          ),
        );
        if (r.isNotEmpty) {
          add(
            LoadAgreementHtml(
              shortName: r.first.shortName,
              htmlUrl: r.first.htmlFile,
            ),
          );
        }
      },
    );
  }

  Future<void> _onLoadAgreementHtml(
    LoadAgreementHtml event,
    Emitter<IWalletAgreementsState> emit,
  ) async {
    if (state.htmlContents.containsKey(event.shortName)) {
      return;
    }

    final loadingHtml = Map<String, bool>.from(state.loadingHtml);
    loadingHtml[event.shortName] = true;
    emit(state.copyWith(loadingHtml: loadingHtml));

    try {
      final response = await _dio.get<String>(
        event.htmlUrl,
        options: Options(responseType: ResponseType.plain),
      );

      final htmlContents = Map<String, String>.from(state.htmlContents);
      htmlContents[event.shortName] = response.data ?? '';

      loadingHtml[event.shortName] = false;
      emit(
        state.copyWith(
          htmlContents: htmlContents,
          loadingHtml: loadingHtml,
        ),
      );
    } on Exception catch (e) {
      LogHelper.log(LogLevel.error, 'HTML yükleme hatası: $e');
      loadingHtml[event.shortName] = false;
      emit(
        state.copyWith(
          loadingHtml: loadingHtml,
        ),
      );
    }
  }

  Future<void> _onAcceptCurrentAgreement(
    AcceptCurrentAgreement event,
    Emitter<IWalletAgreementsState> emit,
  ) async {
    if (state.currentAgreement == null) return;

    final shortName = state.currentAgreement!.shortName;
    final newAccepted = Set<String>.from(state.acceptedAgreements)
      ..add(shortName);

    if (state.selectedIndex < state.agreements.length - 1) {
      final nextIndex = state.selectedIndex + 1;
      emit(
        state.copyWith(
          acceptedAgreements: newAccepted,
          selectedIndex: nextIndex,
        ),
      );

      final nextAgreement = state.agreements[nextIndex];
      if (!state.htmlContents.containsKey(nextAgreement.shortName)) {
        add(
          LoadAgreementHtml(
            shortName: nextAgreement.shortName,
            htmlUrl: nextAgreement.htmlFile,
          ),
        );
      }
    } else {
      emit(state.copyWith(acceptedAgreements: newAccepted));
    }
  }
}
