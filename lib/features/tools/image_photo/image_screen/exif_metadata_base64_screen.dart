import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../image_utils/image_models.dart';

class ExifMetadataBase64Screen extends StatelessWidget {
  const ExifMetadataBase64Screen({super.key});

  @override
  Widget build(BuildContext context) {
    const sampleBase64 = "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAP... [Sample Image Data String]";

    return Scaffold(
      appBar: AppBar(title: const Text('EXIF Metadata & Base64 Encoder')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          imgHero('EXIF & Base64 Inspector', 'View photo camera metadata & encode images to Base64 URI', Colors.deepOrange, Icons.camera_enhance),
          const SizedBox(height: 16),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.blue),
                  title: Text('Camera Model'),
                  subtitle: Text('Sony Alpha 7 IV', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.shutter_speed, color: Colors.green),
                  title: Text('Aperture & Shutter'),
                  subtitle: Text('f/1.8 • 1/500s • ISO 100', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.straighten, color: Colors.orange),
                  title: Text('Focal Length'),
                  subtitle: Text('50mm Fixed Prime Lens', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.aspect_ratio, color: Colors.purple),
                  title: Text('Resolution'),
                  subtitle: Text('6000 x 4000 Pixels (24 MP)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Base64 Data String', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.blue),
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: sampleBase64));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Base64 string copied!')));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const SelectableText(
                    sampleBase64,
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
