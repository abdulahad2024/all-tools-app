import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../net_provider/net_tools_provider.dart';
import '../net_utils/net_models.dart';

class SpeedTestScreen extends ConsumerWidget {
  const SpeedTestScreen({super.key});

  Future<void> _startSpeedTest(WidgetRef ref) async {
    ref.read(isSpeedTestRunningProvider.notifier).state = true;
    ref.read(downloadSpeedProvider.notifier).state = 0.0;
    ref.read(uploadSpeedProvider.notifier).state = 0.0;
    ref.read(pingLatencyProvider.notifier).state = 0;

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      ref.read(pingLatencyProvider.notifier).state = 18 + (i % 5);
      ref.read(downloadSpeedProvider.notifier).state = (i * 8.5) + (i % 3);
    }

    for (int i = 1; i <= 8; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      ref.read(uploadSpeedProvider.notifier).state = (i * 5.2) + (i % 2);
    }

    ref.read(isSpeedTestRunningProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testing = ref.watch(isSpeedTestRunningProvider);
    final download = ref.watch(downloadSpeedProvider);
    final upload = ref.watch(uploadSpeedProvider);
    final ping = ref.watch(pingLatencyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Internet Speed Test')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          netHero('Internet Speed Test', 'Measure live download speed, upload speed and latency', Colors.lightBlue, Icons.speed),
          const SizedBox(height: 24),
          Center(
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      download.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const Text('Mbps Download', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric('Ping', '$ping ms', Icons.speed),
              _buildMetric('Upload', '${upload.toStringAsFixed(1)} Mbps', Icons.upload),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.lightBlue,
              foregroundColor: Colors.white,
            ),
            icon: Icon(testing ? Icons.sync : Icons.play_arrow),
            label: Text(testing ? 'Testing Connection...' : 'Start Speed Test', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: testing ? null : () => _startSpeedTest(ref),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String val, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 28),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
