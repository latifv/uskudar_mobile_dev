part of 'address_preview_bloc.dart';

sealed class AddressPreviewEvent {
  const AddressPreviewEvent();
}

final class AddressPreviewStarted extends AddressPreviewEvent {
  const AddressPreviewStarted();
}

final class AddressPreviewApproved extends AddressPreviewEvent {
  const AddressPreviewApproved({
    required this.isManuel,
    this.address,
  });

  final bool isManuel;
  final String? address;
}
