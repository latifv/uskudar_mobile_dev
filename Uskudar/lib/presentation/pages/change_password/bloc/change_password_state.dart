part of 'change_password_bloc.dart';

enum ChangePasswordBlocState { initial, loading, success, error }

final class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.key,
    this.state = ChangePasswordBlocState.initial,
    this.message,
  });
  final Key? key;
  final ChangePasswordBlocState state;
  final String? message;

  ChangePasswordState copyWith({
    Key? key,
    ChangePasswordBlocState? state,
    String? message,
  }) {
    return ChangePasswordState(
      key: key ?? this.key,
      state: state ?? this.state,
      message: message,
    );
  }

  @override
  List<Object?> get props => [key, state, message];
}
