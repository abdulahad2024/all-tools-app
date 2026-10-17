import 'package:flutter_riverpod/flutter_riverpod.dart';

final wordCounterTextProvider = StateProvider<String>((ref) => '');
final pomodoroSecondsLeftProvider = StateProvider<int>((ref) => 25 * 60);
final isPomodoroRunningProvider = StateProvider<bool>((ref) => false);
