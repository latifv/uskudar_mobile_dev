part of 'iwallet_agreements_bloc.dart';

enum IWalletAgreementsStatus {
  initial,
  loading,
  loaded,
  error,
}

final class IWalletAgreementsState extends Equatable {
  const IWalletAgreementsState({
    this.status = IWalletAgreementsStatus.initial,
    this.agreements = const [],
    this.message,
    this.selectedIndex = 0,
    this.acceptedAgreements = const {},
    this.htmlContents = const {},
    this.loadingHtml = const {},
  });

  final IWalletAgreementsStatus status;
  final List<IWalletAgreement> agreements;
  final String? message;
  final int selectedIndex;
  final Set<String> acceptedAgreements;
  final Map<String, String> htmlContents;
  final Map<String, bool> loadingHtml;

  bool get allAgreementsAccepted =>
      acceptedAgreements.length == agreements.length;

  IWalletAgreement? get currentAgreement {
    if (selectedIndex < agreements.length) {
      return agreements[selectedIndex];
    }
    return null;
  }

  bool get isLastAgreement => selectedIndex >= agreements.length - 1;

  IWalletAgreementsState copyWith({
    IWalletAgreementsStatus? status,
    List<IWalletAgreement>? agreements,
    String? message,
    int? selectedIndex,
    Set<String>? acceptedAgreements,
    Map<String, String>? htmlContents,
    Map<String, bool>? loadingHtml,
  }) {
    return IWalletAgreementsState(
      status: status ?? this.status,
      agreements: agreements ?? this.agreements,
      message: message,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      acceptedAgreements: acceptedAgreements ?? this.acceptedAgreements,
      htmlContents: htmlContents ?? this.htmlContents,
      loadingHtml: loadingHtml ?? this.loadingHtml,
    );
  }

  @override
  List<Object?> get props => [
    status,
    agreements,
    message,
    selectedIndex,
    acceptedAgreements,
    htmlContents,
    loadingHtml,
  ];
}
