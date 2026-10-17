import 'package:flutter_riverpod/flutter_riverpod.dart';

final isRecordingProvider = StateProvider<bool>((ref) => false);
final recordingSecondsProvider = StateProvider<int>((ref) => 0);
