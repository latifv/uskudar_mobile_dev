part of 'change_phone_bloc.dart';

enum ChangePhoneBlocState { initial, loading, loaded, success, error }

final class ChangePhoneState extends Equatable {
  const ChangePhoneState({
    this.key,
    this.state = ChangePhoneBlocState.initial,
    this.message,
    this.processCode,
  });
  final Key? key;
  final ChangePhoneBlocState state;
  final String? message;
  final String? processCode;

  ChangePhoneState copyWith({
    Key? key,
    ChangePhoneBlocState? state,
    String? message,
    String? processCode,
  }) {
    return ChangePhoneState(
      key: key ?? this.key,
      state: state ?? this.state,
      message: message,
      processCode: processCode ?? this.processCode,
    );
  }

  @override
  List<Object?> get props => [key, state, message, processCode];
}
