part of 'address_preview_bloc.dart';

enum AddressPreviewStatus { loading, loaded, processing, approved, error }

final class AddressPreviewState extends Equatable {
  const AddressPreviewState({
    this.status = AddressPreviewStatus.loading,
    this.userAddressInformation,
    this.message,
  });

  final AddressPreviewStatus status;
  final UserAddressInformation? userAddressInformation;
  final String? message;

  AddressPreviewState copyWith({
    AddressPreviewStatus? status,
    UserAddressInformation? userAddressInformation,
    String? message,
  }) {
    return AddressPreviewState(
      status: status ?? this.status,
      userAddressInformation:
          userAddressInformation ?? this.userAddressInformation,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, userAddressInformation, message];
}
