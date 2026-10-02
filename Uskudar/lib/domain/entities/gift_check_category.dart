class GiftCheckCategory {
  const GiftCheckCategory({required this.id, required this.name});

  final String id;
  final String name;
}

extension GiftCheckCategoryExtension on GiftCheckCategory {
  bool get isLioCard {
    final normalizedName = name
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ğ', 'g')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp('[^a-z0-9]'), '');

    return normalizedName == 'liokart';
  }
}
