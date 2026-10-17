import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../media_provider/media_tools_provider.dart';
import '../media_utils/media_models.dart';

class VoiceRecorderScreen extends ConsumerStatefulWidget {
  const VoiceRecorderScreen({super.key});

  @override
  ConsumerState<VoiceRecorderScreen> createState() => _VoiceRecorderScreenState();
}

class _VoiceRecorderScreenState extends ConsumerState<VoiceRecorderScreen> {
  Timer? _timer;

  void _toggleRecording() {
    final isRecording = ref.read(isRecordingProvider);
    if (isRecording) {
      _timer?.cancel();
      ref.read(isRecordingProvider.notifier).state = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio clip recorded & saved successfully!')),
      );
    } else {
      ref.read(isRecordingProvider.notifier).state = true;
      ref.read(recordingSecondsProvider.notifier).state = 0;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        ref.read(recordingSecondsProvider.notifier).state++;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = ref.watch(isRecordingProvider);
    final seconds = ref.watch(recordingSecondsProvider);

    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    String timeStr = '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(title: const Text('Voice Recorder')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          mediaHero('Voice & Audio Recorder', 'Record clean high-quality voice audio clips offline', Colors.amber.shade800, Icons.mic),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording ? Colors.red.shade100 : Colors.blue.shade100,
                  ),
                  child: Icon(
                    isRecording ? Icons.mic : Icons.mic_none,
                    size: 80,
                    color: isRecording ? Colors.red : Colors.blue,
                  ),
                ),
                const SizedBox(height: 24),
                Text(timeStr, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold)),
                const SizedBox(height: 36),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRecording ? Colors.red : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  icon: Icon(isRecording ? Icons.stop : Icons.fiber_manual_record),
                  label: Text(isRecording ? 'Stop Recording' : 'Start Recording', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: _toggleRecording,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
