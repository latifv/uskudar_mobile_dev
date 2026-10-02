import 'package:equatable/equatable.dart';

final class AvatarImage extends Equatable {
  const AvatarImage({this.id, this.genderTypes, this.image});

  final int? id;
  final int? genderTypes;
  final String? image;

  @override
  List<Object?> get props => [id, genderTypes, image];
}
