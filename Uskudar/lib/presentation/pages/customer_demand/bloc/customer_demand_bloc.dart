import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/customer_demand_subject.dart';
import 'package:payinall/domain/params/create_customer_demand_params.dart';
import 'package:payinall/domain/usecases/create_customer_demand_usecase.dart';
import 'package:payinall/domain/usecases/get_customer_demand_subject_types_usecase.dart';

part 'customer_demand_event.dart';
part 'customer_demand_state.dart';

final class CustomerDemandBloc
    extends Bloc<CustomerDemandEvent, CustomerDemandState> {
  CustomerDemandBloc({
    required GetCustomerDemandSubjectTypesUsecase
    getCustomerDemandSubjectTypesUsecase,
    required CreateCustomerDemandUsecase createCustomerDemandUsecase,
  }) : _getSubjectTypesUsecase = getCustomerDemandSubjectTypesUsecase,
       _createDemandUsecase = createCustomerDemandUsecase,
       super(const CustomerDemandState()) {
    on<CustomerDemandLoadSubjects>(_onLoadSubjects);
    on<CustomerDemandSubmit>(_onSubmit);
  }

  final GetCustomerDemandSubjectTypesUsecase _getSubjectTypesUsecase;
  final CreateCustomerDemandUsecase _createDemandUsecase;

  Future<void> _onLoadSubjects(
    CustomerDemandLoadSubjects event,
    Emitter<CustomerDemandState> emit,
  ) async {
    emit(state.copyWith(status: CustomerDemandStatus.loading));

    final result = await _getSubjectTypesUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CustomerDemandStatus.error,
          message: failure.message,
        ),
      ),
      (subjects) => emit(
        state.copyWith(
          status: CustomerDemandStatus.loaded,
          subjects: subjects,
        ),
      ),
    );
  }

  Future<void> _onSubmit(
    CustomerDemandSubmit event,
    Emitter<CustomerDemandState> emit,
  ) async {
    emit(state.copyWith(status: CustomerDemandStatus.submitting));

    final params = CreateCustomerDemandParams(
      requestSubjectId: event.requestSubjectId,
      title: event.title,
      content: event.content,
    );

    final result = await _createDemandUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CustomerDemandStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: CustomerDemandStatus.success,
          message: message,
        ),
      ),
    );
  }
}
