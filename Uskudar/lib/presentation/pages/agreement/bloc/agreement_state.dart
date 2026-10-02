part of 'agreement_bloc.dart';

enum AgreementBlocStatus { initial, loading, loaded, error }

final class AgreementState extends Equatable {
  const AgreementState({
    this.status = AgreementBlocStatus.initial,
    this.htmlText,
    this.message,
  });
  final AgreementBlocStatus status;
  final String? htmlText;
  final String? message;

  AgreementState copyWith({
    AgreementBlocStatus? status,
    String? htmlText,
    String? message,
  }) => AgreementState(
    status: status ?? this.status,
    htmlText: htmlText ?? this.htmlText,
    message: message,
  );

  @override
  List<Object?> get props => [status, htmlText, message];
}
