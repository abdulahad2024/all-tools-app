import 'package:flutter/material.dart';

class GpsSpeedometerScreen extends StatelessWidget {
  const GpsSpeedometerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPS Speedometer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('0', style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.blue)),
                    Text('km/h', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [Text('Top Speed', style: TextStyle(color: Colors.grey)), Text('0 km/h', style: TextStyle(fontWeight: FontWeight.bold))]),
                Column(children: [Text('Avg Speed', style: TextStyle(color: Colors.grey)), Text('0 km/h', style: TextStyle(fontWeight: FontWeight.bold))]),
              ],
            )
          ],
        ),
      ),
    );
  }
}
