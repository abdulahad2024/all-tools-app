import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pdf_utils/pdf_models.dart';

final pdfCompressionQualityProvider = StateProvider<double>((ref) => 50);
final pdfWatermarkTextProvider = StateProvider<String>((ref) => 'CONFIDENTIAL');
final pdfPasswordProvider = StateProvider<String>((ref) => '123456');
final pdfIsPasswordObscuredProvider = StateProvider<bool>((ref) => true);

class PdfCompressWatermarkScreen extends ConsumerWidget {
  final String mode; // 'compress', 'watermark', 'lock'
  const PdfCompressWatermarkScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quality = ref.watch(pdfCompressionQualityProvider);
    final watermarkText = ref.watch(pdfWatermarkTextProvider);
    final password = ref.watch(pdfPasswordProvider);
    final isObscured = ref.watch(pdfIsPasswordObscuredProvider);

    String title = 'PDF Utility';
    Color color = Colors.purple;
    IconData icon = Icons.build;

    if (mode == 'compress') {
      title = 'PDF Compressor';
      color = Colors.indigo;
      icon = Icons.compress;
    } else if (mode == 'watermark') {
      title = 'PDF Watermark Creator';
      color = Colors.purple;
      icon = Icons.branding_watermark;
    } else if (mode == 'lock') {
      title = 'PDF Lock / Unlock';
      color = Colors.cyan.shade800;
      icon = Icons.security;
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          pdfHero(title, 'Optimize and protect your PDF documents', color, icon),
          const SizedBox(height: 16),
          if (mode == 'compress') ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Compression Level: ${quality.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Slider(
                      value: quality,
                      min: 10,
                      max: 90,
                      divisions: 16,
                      onChanged: (val) => ref.read(pdfCompressionQualityProvider.notifier).state = val,
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Original Size: 8.5 MB', style: TextStyle(color: Colors.grey)),
                        Text('Estimated Size: 2.1 MB', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ] else if (mode == 'watermark') ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: watermarkText,
                      decoration: const InputDecoration(labelText: 'Watermark Text', border: OutlineInputBorder()),
                      onChanged: (val) => ref.read(pdfWatermarkTextProvider.notifier).state = val,
                    ),
                  ],
                ),
              ),
            ),
          ] else if (mode == 'lock') ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: password,
                      obscureText: isObscured,
                      decoration: InputDecoration(
                        labelText: 'PDF Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => ref.read(pdfIsPasswordObscuredProvider.notifier).state = !isObscured,
                        ),
                      ),
                      onChanged: (val) => ref.read(pdfPasswordProvider.notifier).state = val,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            icon: Icon(icon),
            label: const Text('Apply & Process PDF', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title completed successfully!'),
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
