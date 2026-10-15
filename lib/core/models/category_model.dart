import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String nameEn;
  final String nameBn;
  final String descriptionEn;
  final String descriptionBn;
  final IconData icon;
  final Color color;

  const CategoryModel({
    required this.id,
    required this.nameEn,
    required this.nameBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.icon,
    required this.color,
  });

  String getName(String locale) => locale == 'bn' ? nameBn : nameEn;
  String getDescription(String locale) => locale == 'bn' ? descriptionBn : descriptionEn;
}
