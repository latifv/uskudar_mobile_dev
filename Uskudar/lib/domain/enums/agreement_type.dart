enum AgreementType {
  hakemHeyeti('HHY'),
  guvenlikSozlesmesi('KGS'),
  bilgilendirmeMetni('BM'),
  adresBilgisiSozlesmesi('ABS'),
  kullaniciCerceveSozlesmesi('KCS'),
  musteriEdinimiUzaktanKimlikTespitiAydinlatmaMetni('MEUKTAM'),
  odemeHizmetiKullanicilariAydinlatmaMetni('OHKAYM'),
  biyometrikVeriRizasi('BVR');

  const AgreementType(this._value);
  final String _value;

  String get getValue => _value;
}

extension AgreementTypeExtension on String {
  AgreementType toAgreementType() {
    return AgreementType.values.firstWhere((type) => type.getValue == this);
  }
}
