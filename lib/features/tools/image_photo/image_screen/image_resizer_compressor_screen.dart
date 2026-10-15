import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/file_save_service.dart';
import '../image_provider/image_tools_provider.dart';
import '../image_utils/image_models.dart';

class ImageResizerCompressorScreen extends ConsumerStatefulWidget {
  const ImageResizerCompressorScreen({super.key});

  @override
  ConsumerState<ImageResizerCompressorScreen> createState() => _ImageResizerCompressorScreenState();
}

class _ImageResizerCompressorScreenState extends ConsumerState<ImageResizerCompressorScreen> {
  double _rotationAngle = 0.0;
  String _aspectRatio = 'Free';

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? img = await picker.pickImage(source: source);
      if (img != null) {
        ref.read(imageResizerProvider.notifier).setImage(img);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  void _showImageSourceModal() {
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
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('Capture with Camera'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(imageResizerProvider);
    final notifier = ref.read(imageResizerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Image Resizer, Compressor & Crop')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          imgHero('Image Processing Tools', 'Resize, compress, crop, rotate & convert photo format (JPG/PNG/WebP)', Colors.purple, Icons.compress),
          const SizedBox(height: 16),
          Container(
            height: 240,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: InkWell(
              onTap: _showImageSourceModal,
              borderRadius: BorderRadius.circular(16),
              child: state.image != null
                  ? Transform.rotate(
                      angle: _rotationAngle * (3.141592653589793 / 180),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: kIsWeb
                            ? Image.network(state.image!.path, fit: BoxFit.contain, width: double.infinity)
                            : Image.file(File(state.image!.path), fit: BoxFit.contain, width: double.infinity),
                      ),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 64, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Tap to select an image from Gallery or Camera', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Compression Quality: ${state.quality.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: state.quality,
                    min: 10,
                    max: 100,
                    divisions: 18,
                    onChanged: (val) => notifier.setQuality(val),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Rotation Angle:', style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.rotate_right),
                        onPressed: () {
                          setState(() {
                            _rotationAngle = (_rotationAngle + 90) % 360;
                          });
                        },
                      ),
                      Text('${_rotationAngle.toInt()}°', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Crop Ratio:', style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: _aspectRatio,
                        items: ['Free', '1:1 Square', '4:3 Standard', '16:9 Widescreen'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                        onChanged: (val) => setState(() => _aspectRatio = val!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Target Format:', style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: state.format,
                        items: ['JPG', 'PNG', 'WebP'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                        onChanged: (val) {
                          if (val != null) notifier.setFormat(val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.save_alt),
            label: const Text('Process & Save Image to Device', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () async {
              if (state.image == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select an image first.')),
                );
                return;
              }
              await FileSaveService.saveImageToDevice(context, state.image!, 'Processed_Image');
            },
          ),
        ],
      ),
    );
  }
}
