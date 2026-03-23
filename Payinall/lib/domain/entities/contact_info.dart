import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class ContactInfoModel extends Equatable {
  const ContactInfoModel({
    required this.title,
    required this.content,
    required this.iconData,
    this.isLink = true,
  });

  final String title;
  final String content;
  final IconData iconData;
  final bool isLink;

  @override
  List<Object?> get props => [title, content, iconData, isLink];
}

final class SocialMediaModel extends Equatable {
  const SocialMediaModel({required this.iconData, required this.url});

  final IconData iconData;
  final String url;

  @override
  List<Object?> get props => [iconData, url];
}

final class ContactInfoSectionModel extends Equatable {
  const ContactInfoSectionModel({required this.title, required this.items});

  final String title;
  final List<ContactInfoModel> items;

  @override
  List<Object?> get props => [title, items];
}
