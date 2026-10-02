part of 'registered_users_bloc.dart';

enum RegisteredUsersStatus { initial, loading, loaded, error, actionSuccess }

final class RegisteredUsersState extends Equatable {
  const RegisteredUsersState({
    this.status = RegisteredUsersStatus.initial,
    this.frequentlySents = const [],
    this.frequentIbans = const [],
    this.activeTab = 0,
    this.message,
  });

  final RegisteredUsersStatus status;
  final List<FrequentlySent> frequentlySents;
  final List<FrequentIban> frequentIbans;
  final int activeTab;
  final String? message;

  RegisteredUsersState copyWith({
    RegisteredUsersStatus? status,
    List<FrequentlySent>? frequentlySents,
    List<FrequentIban>? frequentIbans,
    int? activeTab,
    String? message,
  }) {
    return RegisteredUsersState(
      status: status ?? this.status,
      frequentlySents: frequentlySents ?? this.frequentlySents,
      frequentIbans: frequentIbans ?? this.frequentIbans,
      activeTab: activeTab ?? this.activeTab,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    frequentlySents,
    frequentIbans,
    activeTab,
    message,
  ];
}
