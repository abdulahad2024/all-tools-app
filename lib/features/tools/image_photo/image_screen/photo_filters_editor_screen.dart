import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../image_provider/image_tools_provider.dart';
import '../image_utils/image_models.dart';

class PhotoFiltersEditorScreen extends ConsumerStatefulWidget {
  const PhotoFiltersEditorScreen({super.key});

  @override
  ConsumerState<PhotoFiltersEditorScreen> createState() => _PhotoFiltersEditorScreenState();
}

class _PhotoFiltersEditorScreenState extends ConsumerState<PhotoFiltersEditorScreen> {
  XFile? _selectedImage;
  double _blurValue = 0.0;

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => _selectedImage = img);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeFilter = ref.watch(activeFilterProvider);
    final watermarkText = ref.watch(watermarkCaptionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Photo Filters & Meme Editor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          imgHero('Photo Filters & Watermark', 'Apply color filters, blur effects, text watermark & meme captions', Colors.pink, Icons.auto_fix_high),
          const SizedBox(height: 16),
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: InkWell(
              onTap: _pickPhoto,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: kIsWeb
                              ? Image.network(_selectedImage!.path, fit: BoxFit.cover, width: double.infinity)
                              : Image.file(File(_selectedImage!.path), fit: BoxFit.cover, width: double.infinity),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 64, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Tap to select photo from Gallery', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            ],
                          ),
                        ),
                  if (watermarkText.isNotEmpty && _selectedImage != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(12)),
                      child: Text(watermarkText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filter Preset:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Normal', 'Vivid', 'Grayscale', 'Sepia', 'Vintage'].map((f) {
                      bool isSelected = activeFilter == f;
                      return ChoiceChip(
                        label: Text(f),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) ref.read(activeFilterProvider.notifier).state = f;
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('Blur Effect: ${_blurValue.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: _blurValue,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChanged: (val) => setState(() => _blurValue = val),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: watermarkText,
                    decoration: const InputDecoration(labelText: 'Watermark / Meme Text', border: OutlineInputBorder()),
                    onChanged: (val) => ref.read(watermarkCaptionProvider.notifier).state = val,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.download),
            label: const Text('Export Filtered Image', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              if (_selectedImage == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a photo first!')));
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Photo exported with $activeFilter filter successfully!'),
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
