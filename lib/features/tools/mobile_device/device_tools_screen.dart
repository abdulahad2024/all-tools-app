import 'package:flutter/material.dart';

class DeviceSpecsScreen extends StatelessWidget {
  const DeviceSpecsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Specs & System Info')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.phone_android, color: Colors.blue),
              title: Text('Device Model'),
              subtitle: Text('Android / iOS Cross-Platform Device', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.memory, color: Colors.green),
              title: Text('Processor (CPU)'),
              subtitle: Text('Octa-core 2.84 GHz ARM64', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.developer_board, color: Colors.purple),
              title: Text('System RAM'),
              subtitle: Text('8.00 GB LPDDR5', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.battery_charging_full, color: Colors.amber),
              title: Text('Battery Status'),
              subtitle: Text('98% (Good Health)', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.aspect_ratio, color: Colors.deepOrange),
              title: Text('Screen Resolution'),
              subtitle: Text('1080 x 2400 pixels (~400 ppi)', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
