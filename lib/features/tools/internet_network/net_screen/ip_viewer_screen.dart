import 'package:flutter/material.dart';
import '../net_utils/net_models.dart';

class IpViewerScreen extends StatelessWidget {
  const IpViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IP Address & Network Info')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          netHero('IP & Network Inspector', 'View public & local IPv4/IPv6, subnet mask & gateway details', Colors.blue, Icons.lan),
          const SizedBox(height: 16),
          const Card(
            child: ListTile(
              leading: Icon(Icons.wifi, color: Colors.blue),
              title: Text('Local IPv4 Address'),
              subtitle: Text('192.168.0.105', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.public, color: Colors.green),
              title: Text('Public IPv4 Address'),
              subtitle: Text('103.112.54.21', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.lan, color: Colors.orange),
              title: Text('Subnet Mask'),
              subtitle: Text('255.255.255.0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.router, color: Colors.purple),
              title: Text('Default Gateway'),
              subtitle: Text('192.168.0.1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
