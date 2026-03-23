import 'package:equatable/equatable.dart';

final class AppPageItem extends Equatable {
  const AppPageItem({
    required this.routeName,
    required this.title,
    required this.description,
    this.productId,
  });

  final String routeName;
  final String title;
  final String description;
  final String? productId;

  bool get isBillProduct => productId != null;

  @override
  List<Object?> get props => [routeName, title, description, productId];
}
