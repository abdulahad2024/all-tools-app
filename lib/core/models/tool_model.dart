import 'package:flutter/material.dart';

class ToolModel {
  final String id;
  final String categoryId;
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final IconData icon;
  final bool isPopular;
  final List<String> tags;

  const ToolModel({
    required this.id,
    required this.categoryId,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.icon,
    this.isPopular = false,
    this.tags = const [],
  });

  String getTitle(String locale) => locale == 'bn' ? titleBn : titleEn;
  String getDescription(String locale) => locale == 'bn' ? descriptionBn : descriptionEn;
}
