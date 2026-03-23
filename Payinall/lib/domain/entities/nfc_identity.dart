import 'package:equatable/equatable.dart';

final class NfcIdentity extends Equatable {
  const NfcIdentity({
    this.dg1Base64,
    this.efComBase64,
    this.dg5Base64,
    this.dg2Base64,
    this.dg3Base64,
    this.dg4Base64,
    this.dg6Base64,
    this.dg7Base64,
    this.dg8Base64,
    this.dg9Base64,
    this.dg10Base64,
    this.dg11Base64,
    this.dg12Base64,
    this.dg13Base64,
    this.dg14Base64,
    this.dg15Base64,
    this.dg16Base64,
    this.activeAuthenticationResponseBase64,
    this.challangeBase64,
    this.efSodBase64,
  });
  factory NfcIdentity.fromMap(Map<dynamic, dynamic> map) {
    return NfcIdentity(
      dg1Base64: map['DG1Base64'] as String?,
      efComBase64: map['efComBase64'] as String?,
      dg5Base64: map['DG5Base64'] as String?,
      dg2Base64: map['DG2Base64'] as String?,
      dg3Base64: map['DG3Base64'] as String?,
      dg4Base64: map['DG4Base64'] as String?,
      dg6Base64: map['DG6Base64'] as String?,
      dg7Base64: map['DG7Base64'] as String?,
      dg8Base64: map['DG8Base64'] as String?,
      dg9Base64: map['DG9Base64'] as String?,
      dg10Base64: map['DG10Base64'] as String?,
      dg11Base64: map['DG11Base64'] as String?,
      dg12Base64: map['DG12Base64'] as String?,
      dg13Base64: map['DG13Base64'] as String?,
      dg14Base64: map['DG14Base64'] as String?,
      dg15Base64: map['DG15Base64'] as String?,
      activeAuthenticationResponseBase64:
          map['activeAuthenticationResponseBase64'] as String?,
      challangeBase64: map['challangeBase64'] as String?,
      efSodBase64: map['efSodBase64'] as String?,
      dg16Base64: map['DG16Base64'] as String?,
    );
  }

  final String? dg1Base64;
  final String? efComBase64;
  final String? dg5Base64;
  final String? dg2Base64;
  final String? dg3Base64;
  final String? dg4Base64;
  final String? dg6Base64;
  final String? dg7Base64;
  final String? dg8Base64;
  final String? dg9Base64;
  final String? dg10Base64;
  final String? dg11Base64;
  final String? dg12Base64;
  final String? dg13Base64;
  final String? dg14Base64;
  final String? dg15Base64;
  final String? dg16Base64;
  final String? activeAuthenticationResponseBase64;
  final String? challangeBase64;
  final String? efSodBase64;

  @override
  String toString() {
    return 'NfcIdentity(dg1Base64: $dg1Base64, efComBase64: $efComBase64, dg5Base64: $dg5Base64, dg2Base64: $dg2Base64, dg3Base64: $dg3Base64, dg4Base64: $dg4Base64, dg6Base64: $dg6Base64, dg7Base64: $dg7Base64, dg8Base64: $dg8Base64, dg9Base64: $dg9Base64, dg10Base64: $dg10Base64, dg11Base64: $dg11Base64, dg12Base64: $dg12Base64, dg13Base64: $dg13Base64, dg14Base64: $dg14Base64, dg15Base64: $dg15Base64, dg16Base64: $dg16Base64, activeAuthenticationResponseBase64: $activeAuthenticationResponseBase64, challangeBase64: $challangeBase64, efSodBase64: $efSodBase64)';
  }

  @override
  List<Object?> get props => [
    dg1Base64,
    efComBase64,
    dg5Base64,
    dg2Base64,
    dg3Base64,
    dg4Base64,
    dg6Base64,
    dg7Base64,
    dg8Base64,
    dg9Base64,
    dg10Base64,
    dg11Base64,
    dg12Base64,
    dg13Base64,
    dg14Base64,
    dg15Base64,
    dg16Base64,
    activeAuthenticationResponseBase64,
    challangeBase64,
    efSodBase64,
  ];
}
