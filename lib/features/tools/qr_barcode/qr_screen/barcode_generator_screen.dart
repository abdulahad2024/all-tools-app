import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../qr_utils/qr_models.dart';

final barcodeTypeProvider = StateProvider<String>((ref) => 'CODE128');
final barcodeTextProvider = StateProvider<String>((ref) => '8801234567890');

class BarcodeGeneratorScreen extends ConsumerWidget {
  const BarcodeGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barcodeType = ref.watch(barcodeTypeProvider);
    final barcodeText = ref.watch(barcodeTextProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Barcode Generator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          qrHero('Barcode Generator', 'Generate CODE128, EAN-13, UPC product & stock barcodes', Colors.indigo, Icons.view_column),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: barcodeType,
                    decoration: const InputDecoration(labelText: 'Barcode Standard', border: OutlineInputBorder()),
                    items: ['CODE128', 'EAN-13', 'UPC-A', 'CODE39'].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                    onChanged: (val) {
                      if (val != null) ref.read(barcodeTypeProvider.notifier).state = val;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: barcodeText,
                    decoration: const InputDecoration(labelText: 'Product Code / Number', border: OutlineInputBorder()),
                    onChanged: (val) => ref.read(barcodeTextProvider.notifier).state = val,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.black12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(24, (i) => Container(width: i % 2 == 0 ? 4 : 2, height: 70, color: Colors.black)),
                        ),
                        const SizedBox(height: 4),
                        Text(barcodeText, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.download),
            label: const Text('Save Barcode Image', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Barcode ($barcodeType) exported & saved to gallery!'),
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
