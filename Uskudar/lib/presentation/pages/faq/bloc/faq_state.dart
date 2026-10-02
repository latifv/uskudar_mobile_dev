part of 'faq_bloc.dart';

enum FaqStatus { initial, loading, loaded, error }

final class FaqState extends Equatable {
  const FaqState({
    this.status = FaqStatus.initial,
    this.helps,
    this.message,
    this.key,
    this.expandStates = const {},
  });
  final Key? key;
  final FaqStatus status;
  final List<Help>? helps;
  final String? message;
  final Map<int, bool> expandStates;

  FaqState copyWith({
    FaqStatus? status,
    List<Help>? helps,
    String? message,
    Key? key,
    Map<int, bool>? expandStates,
  }) {
    return FaqState(
      status: status ?? this.status,
      helps: helps ?? this.helps,
      message: message,
      key: key ?? this.key,
      expandStates: expandStates ?? this.expandStates,
    );
  }

  @override
  List<Object?> get props => [status, helps, message, key, expandStates];
}
