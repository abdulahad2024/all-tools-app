import 'package:flutter/material.dart';

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({super.key});

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  bool _testing = false;
  double _downloadSpeed = 0.0;
  double _uploadSpeed = 0.0;
  int _ping = 0;

  Future<void> _startSpeedTest() async {
    setState(() {
      _testing = true;
      _downloadSpeed = 0;
      _uploadSpeed = 0;
      _ping = 0;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
      setState(() {
        _ping = 18 + (i % 5);
        _downloadSpeed = (i * 8.5) + (i % 3);
      });
    }

    for (int i = 1; i <= 8; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
      setState(() {
        _uploadSpeed = (i * 5.2) + (i % 2);
      });
    }

    setState(() => _testing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Internet Speed Test')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
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
                      _downloadSpeed.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const Text('Mbps Download', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric('Ping', '$_ping ms', Icons.speed),
                _buildMetric('Upload', '${_uploadSpeed.toStringAsFixed(1)} Mbps', Icons.upload),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
              ),
              icon: Icon(_testing ? Icons.sync : Icons.play_arrow),
              label: Text(_testing ? 'Testing Connection...' : 'Start Speed Test', style: const TextStyle(fontSize: 18)),
              onPressed: _testing ? null : _startSpeedTest,
            ),
          ],
        ),
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
