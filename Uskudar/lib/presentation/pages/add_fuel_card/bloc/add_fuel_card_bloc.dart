import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/params/create_fuel_card_params.dart';
import 'package:uskudar_mobile/domain/usecases/create_fuel_card_usecase.dart';

part 'add_fuel_card_event.dart';
part 'add_fuel_card_state.dart';

final class AddFuelCardBloc extends Bloc<AddFuelCardEvent, AddFuelCardState> {
  AddFuelCardBloc({
    required this.createFuelCardUsecase,
  }) : super(const AddFuelCardState()) {
    on<AddFuelCardSubmit>(_onSubmit);
  }

  final CreateFuelCardUsecase createFuelCardUsecase;

  Future<void> _onSubmit(
    AddFuelCardSubmit event,
    Emitter<AddFuelCardState> emit,
  ) async {
    emit(state.copyWith(status: AddFuelCardStatus.loading));

    final result = await createFuelCardUsecase(
      CreateFuelCardParams(
        cardNo: event.cardNo,
        cardType: event.cardType,
        plate: event.plate,
        fuelType: event.fuelType,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddFuelCardStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: AddFuelCardStatus.success,
          message: message,
        ),
      ),
    );
  }
}
