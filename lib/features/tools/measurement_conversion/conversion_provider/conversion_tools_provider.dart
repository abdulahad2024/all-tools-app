import 'package:flutter_riverpod/flutter_riverpod.dart';

final unitCategoryProvider = StateProvider<String>((ref) => 'Length');
final unitFromProvider = StateProvider<String>((ref) => 'Meter');
final unitToProvider = StateProvider<String>((ref) => 'Kilometer');

final currencyFromProvider = StateProvider<String>((ref) => 'USD');
final currencyToProvider = StateProvider<String>((ref) => 'BDT');
