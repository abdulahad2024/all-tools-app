import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../qr_provider/qr_tools_provider.dart';
import '../qr_utils/qr_models.dart';

class QrGeneratorScreen extends ConsumerWidget {
  const QrGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrType = ref.watch(qrTypeProvider);
    final qrText = ref.watch(qrInputTextProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Generator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          qrHero('QR Code Generator', 'Generate QR codes for Wi-Fi, URL, Contact, Text & Payments', Colors.teal, Icons.qr_code),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['URL', 'Text', 'Wi-Fi', 'Contact', 'Payment'].map((type) {
              bool isSelected = qrType == type;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (val) {
                  if (val) {
                    ref.read(qrTypeProvider.notifier).state = type;
                    if (type == 'Wi-Fi') {
                      ref.read(qrInputTextProvider.notifier).state = 'WIFI:S:HomeNetwork;T:WPA;P:12345678;;';
                    } else if (type == 'Contact') {
                      ref.read(qrInputTextProvider.notifier).state = 'BEGIN:VCARD\nVERSION:3.0\nN:Doe;John\nTEL:+8801700000000\nEND:VCARD';
                    } else if (type == 'Payment') {
                      ref.read(qrInputTextProvider.notifier).state = 'bKash Merchant: 01700000000';
                    } else if (type == 'URL') {
                      ref.read(qrInputTextProvider.notifier).state = 'https://flutter.dev';
                    }
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: qrText,
            maxLines: qrType == 'Contact' ? 4 : 2,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Enter Content for QR Code ($qrType)',
            ),
            onChanged: (val) => ref.read(qrInputTextProvider.notifier).state = val,
          ),
          const SizedBox(height: 24),
          Center(
            child: Card(
              elevation: 6,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: QrImageView(
                  data: qrText.isEmpty ? 'All Tools App' : qrText,
                  version: QrVersions.auto,
                  size: 220.0,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.download),
            label: const Text('Save / Export QR Image', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              ref.read(qrHistoryProvider.notifier).addQrToHistory(qrText);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('QR Code image exported and saved to history!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
