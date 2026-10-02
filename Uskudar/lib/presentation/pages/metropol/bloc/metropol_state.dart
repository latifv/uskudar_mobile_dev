part of 'metropol_bloc.dart';

enum MetropolStatus { initial, loading, loaded, error }

final class MetropolState extends Equatable {
  const MetropolState({
    this.status = MetropolStatus.initial,
    this.userDetail,
    this.balance,
    this.message,
  });

  final MetropolStatus status;
  final MetropolUserDetail? userDetail;
  final MetropolUserBalance? balance;
  final String? message;

  MetropolState copyWith({
    MetropolStatus? status,
    MetropolUserDetail? userDetail,
    MetropolUserBalance? balance,
    String? message,
  }) {
    return MetropolState(
      status: status ?? this.status,
      userDetail: userDetail ?? this.userDetail,
      balance: balance ?? this.balance,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, userDetail, balance, message];
}
