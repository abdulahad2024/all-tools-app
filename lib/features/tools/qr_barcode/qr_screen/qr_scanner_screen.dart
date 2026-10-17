import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../qr_provider/qr_tools_provider.dart';

class QrScannerScreen extends ConsumerWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannedResult = ref.watch(scannedQrResultProvider);
    final history = ref.watch(qrHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('QR & Barcode Scanner')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner, size: 120, color: Colors.blueAccent),
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Simulate Camera Scan'),
                      onPressed: () {
                        const newScan = 'https://alltools.app/scanned-item-8801700';
                        ref.read(scannedQrResultProvider.notifier).state = newScan;
                        ref.read(qrHistoryProvider.notifier).addQrToHistory(newScan);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Scanned Result:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  SelectableText(scannedResult, style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy Result',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: scannedResult));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Result copied to clipboard!')));
                    },
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Recent Scans & Generated History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.qr_code, color: Colors.teal),
                    title: Text(item, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: item));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item copied!')));
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
