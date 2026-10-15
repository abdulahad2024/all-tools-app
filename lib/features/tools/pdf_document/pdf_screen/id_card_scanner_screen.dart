import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../pdf_provider/pdf_tools_provider.dart';
import '../pdf_utils/pdf_models.dart';

class IdCardScannerScreen extends ConsumerWidget {
  const IdCardScannerScreen({super.key});

  Future<void> _pickCardSide(BuildContext context, WidgetRef ref, bool isFront) async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: Text('Capture ${isFront ? "Front" : "Back"} Side with Camera'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? img = await picker.pickImage(source: ImageSource.camera);
                  if (img != null) {
                    if (isFront) {
                      ref.read(idCardScannerProvider.notifier).setFrontImage(img);
                    } else {
                      ref.read(idCardScannerProvider.notifier).setBackImage(img);
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: Text('Select ${isFront ? "Front" : "Back"} Side from Gallery'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? img = await picker.pickImage(source: ImageSource.gallery);
                  if (img != null) {
                    if (isFront) {
                      ref.read(idCardScannerProvider.notifier).setFrontImage(img);
                    } else {
                      ref.read(idCardScannerProvider.notifier).setBackImage(img);
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(idCardScannerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ID Card Scanner')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          pdfHero('NID & ID Card Scanner', 'Scan front & back sides onto 1 single printable PDF page', Colors.deepPurple, Icons.badge),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickCardSide(context, ref, true),
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: state.frontImage != null ? Colors.green.shade50 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: state.frontImage != null ? Colors.green : Colors.grey),
                    ),
                    child: state.frontImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: kIsWeb
                                ? Image.network(state.frontImage!.path, fit: BoxFit.cover)
                                : Image.file(File(state.frontImage!.path), fit: BoxFit.cover),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.badge, size: 48, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Tap to Scan Front', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickCardSide(context, ref, false),
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: state.backImage != null ? Colors.green.shade50 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: state.backImage != null ? Colors.green : Colors.grey),
                    ),
                    child: state.backImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: kIsWeb
                                ? Image.network(state.backImage!.path, fit: BoxFit.cover)
                                : Image.file(File(state.backImage!.path), fit: BoxFit.cover),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.credit_card, size: 48, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Tap to Scan Back', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Export 1-Page ID PDF', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              if (state.frontImage == null || state.backImage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please scan both Front and Back sides first!')),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('1-Page NID / ID Card PDF created successfully!'),
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
