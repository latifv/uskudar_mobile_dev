import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/models/paycore_mobile_models.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_asset_constants.dart';

/// The visual skin of a card. Card numbers and other account data are supplied
/// by the surrounding screen and are deliberately not part of this artwork.
final class UskudarCardArtwork extends StatelessWidget {
  const UskudarCardArtwork({
    required this.brand,
    this.isBack = false,
    super.key,
  });

  final PaycoreCardBrand brand;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: 360,
        height: 227,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF082D50),
                      Color(0xFF0E5485),
                      Color(0xFF1382AA),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: -92,
              top: -145,
              child: Container(
                width: 310,
                height: 310,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .08),
                    width: 32,
                  ),
                ),
              ),
            ),
            Positioned(
              right: -100,
              bottom: -180,
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .06),
                    width: 42,
                  ),
                ),
              ),
            ),
            if (isBack) ..._backContent() else ..._frontContent(),
          ],
        ),
      ),
    );
  }

  List<Widget> _frontContent() => [
    const Positioned(top: 15, right: 18, child: _MunicipalityMark()),
    Positioned(
      left: 23,
      top: 82,
      child: Container(
        width: 42,
        height: 31,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF8E7AC), Color(0xFFC9A85F)],
          ),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFFFF4CB)),
        ),
        child: const Icon(
          Icons.grid_view_rounded,
          size: 24,
          color: Color(0xFF876C37),
        ),
      ),
    ),
    const Positioned(
      left: 76,
      top: 84,
      child: Icon(
        Icons.contactless_rounded,
        color: Color(0xD9FFFFFF),
        size: 24,
      ),
    ),
    Positioned(right: 20, bottom: 16, child: _CardNetworkMark(brand: brand)),
  ];

  List<Widget> _backContent() => [
    const Positioned(
      left: 0,
      right: 0,
      top: 38,
      height: 42,
      child: ColoredBox(color: Color(0xFF122333)),
    ),
    Positioned(
      left: 21,
      right: 21,
      top: 104,
      height: 41,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2F4),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    ),
    const Positioned(left: 20, bottom: 17, child: _MunicipalityMark()),
    Positioned(right: 20, bottom: 18, child: _CardNetworkMark(brand: brand)),
  ];
}

final class _MunicipalityMark extends StatelessWidget {
  const _MunicipalityMark();

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ClipOval(
        child: ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Image.asset(
              IconAssetsConstants.municipalitySeal,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      const SizedBox(width: 7),
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ÜSKÜDAR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          Text(
            'BELEDİYESİ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    ],
  );
}

final class _CardNetworkMark extends StatelessWidget {
  const _CardNetworkMark({required this.brand});

  final PaycoreCardBrand brand;

  @override
  Widget build(BuildContext context) => switch (brand) {
    PaycoreCardBrand.mastercard => SizedBox(
      width: 51,
      height: 31,
      child: Stack(
        children: [
          Positioned(left: 0, child: _circle(const Color(0xFFEB001B))),
          Positioned(right: 0, child: _circle(const Color(0xFFF79E1B))),
        ],
      ),
    ),
    PaycoreCardBrand.visa => const Text(
      'VISA',
      style: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
      ),
    ),
    PaycoreCardBrand.troy => const Text(
      'troy',
      style: TextStyle(
        color: Colors.white,
        fontSize: 27,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
      ),
    ),
    PaycoreCardBrand.unknown => const Icon(
      Icons.credit_card_rounded,
      color: Colors.white,
      size: 30,
    ),
  };

  Widget _circle(Color color) => Container(
    width: 31,
    height: 31,
    decoration: BoxDecoration(
      color: color.withValues(alpha: .94),
      shape: BoxShape.circle,
    ),
  );
}
