import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/file_save_service.dart';
import '../image_provider/image_tools_provider.dart';
import '../image_utils/image_models.dart';

class PassportNidPhotoScreen extends ConsumerStatefulWidget {
  const PassportNidPhotoScreen({super.key});

  @override
  ConsumerState<PassportNidPhotoScreen> createState() => _PassportNidPhotoScreenState();
}

class _PassportNidPhotoScreenState extends ConsumerState<PassportNidPhotoScreen> {
  XFile? _selectedPhoto;
  Color _bgColor = Colors.white;

  Future<void> _pickPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: source);
    if (img != null) {
      setState(() => _selectedPhoto = img);
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
                  _pickPhoto(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('Capture with Camera'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickPhoto(ImageSource.camera);
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
    final countrySpec = ref.watch(passportCountryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Passport & NID Photo Resizer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          imgHero('Passport & NID Resizer', 'Crop, resize and format photos for official passport & NID applications', Colors.teal, Icons.portrait),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: countrySpec,
                    decoration: const InputDecoration(labelText: 'Preset Document Spec', border: OutlineInputBorder()),
                    items: [
                      'Bangladesh Passport (40x50 mm)',
                      'NID / Job Photo (300x300 px)',
                      'US Passport (2x2 inches)',
                    ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) {
                      if (v != null) ref.read(passportCountryProvider.notifier).state = v;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade400, width: 2),
            ),
            child: InkWell(
              onTap: _showImageSourceModal,
              child: _selectedPhoto != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: kIsWeb
                          ? Image.network(_selectedPhoto!.path, fit: BoxFit.contain)
                          : Image.file(File(_selectedPhoto!.path), fit: BoxFit.contain),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.portrait, size: 64, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Tap to Select Passport Photo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
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
                  const Text('Background Color Preset:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildColorChip('White', Colors.white),
                      _buildColorChip('Blue', Colors.lightBlue.shade100),
                      _buildColorChip('Grey', Colors.grey.shade300),
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
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.save),
            label: const Text('Resize & Save Passport Photo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () async {
              if (_selectedPhoto == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please pick a photo first!')));
                return;
              }
              await FileSaveService.saveImageToDevice(context, _selectedPhoto!, 'Passport_Photo');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColorChip(String label, Color color) {
    bool isSelected = _bgColor == color;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _bgColor = color);
      },
    );
  }
}
