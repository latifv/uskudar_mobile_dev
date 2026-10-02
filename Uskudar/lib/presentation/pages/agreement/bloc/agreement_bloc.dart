import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/enums/agreement_type.dart';
import 'package:payinall/domain/usecases/get_contract_by_contract_code_usecase.dart';

part 'agreement_event.dart';
part 'agreement_state.dart';

final class AgreementBloc extends Bloc<AgreementEvent, AgreementState> {
  AgreementBloc({
    required GetContractByContractCodeUsecase getContractByContractCodeUsecase,
  }) : _getContractByContractCodeUsecase = getContractByContractCodeUsecase,
       super(const AgreementState()) {
    on<GetAgreement>(_onGetAgreement);
    on<DeclineAgreement>(_onDeclineAgreement);
  }

  final GetContractByContractCodeUsecase _getContractByContractCodeUsecase;

  Future<void> _onGetAgreement(
    GetAgreement event,
    Emitter<AgreementState> emit,
  ) async {
    emit(state.copyWith(status: AgreementBlocStatus.loading));

    final result = await _getContractByContractCodeUsecase(
      event.agreementType.getValue,
    );

    result.fold(
      (l) {
        emit(
          state.copyWith(status: AgreementBlocStatus.error, message: l.message),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: AgreementBlocStatus.loaded,
            htmlText: r.content,
          ),
        );
      },
    );
  }

  Future<void> _onDeclineAgreement(
    DeclineAgreement event,
    Emitter<AgreementState> emit,
  ) async {
    emit(state.copyWith(status: AgreementBlocStatus.loaded));
  }
}
