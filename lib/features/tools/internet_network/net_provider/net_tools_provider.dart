import 'package:flutter_riverpod/flutter_riverpod.dart';

final isSpeedTestRunningProvider = StateProvider<bool>((ref) => false);
final downloadSpeedProvider = StateProvider<double>((ref) => 0.0);
final uploadSpeedProvider = StateProvider<double>((ref) => 0.0);
final pingLatencyProvider = StateProvider<int>((ref) => 0);
