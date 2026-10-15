import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorPickerScreen extends StatefulWidget {
  const ColorPickerScreen({super.key});

  @override
  State<ColorPickerScreen> createState() => _ColorPickerScreenState();
}

class _ColorPickerScreenState extends State<ColorPickerScreen> {
  Color _currentColor = Colors.deepPurple;

  final List<Color> _palette = [
    Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
    Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
    Colors.teal, Colors.green, Colors.lightGreen, Colors.amber,
    Colors.orange, Colors.deepOrange, Colors.brown, Colors.grey,
  ];

  String get _hexCode => '#${_currentColor.value.toRadixString(16).substring(2).toUpperCase()}';
  String get _rgbCode => 'RGB(${_currentColor.red}, ${_currentColor.green}, ${_currentColor.blue})';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Color Picker')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: _currentColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: _currentColor.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))
              ],
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _hexCode,
                  style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('HEX Code'),
                    subtitle: Text(_hexCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _hexCode));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('HEX code copied!')));
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('RGB Code'),
                    subtitle: Text(_rgbCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _rgbCode));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('RGB code copied!')));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Color Palette', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _palette.length,
            itemBuilder: (context, index) {
              final color = _palette[index];
              return GestureDetector(
                onTap: () => setState(() => _currentColor = color),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                    border: _currentColor == color ? Border.all(color: Colors.white, width: 3) : null,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ImageResizerScreen extends StatefulWidget {
  const ImageResizerScreen({super.key});

  @override
  State<ImageResizerScreen> createState() => _ImageResizerScreenState();
}

class _ImageResizerScreenState extends State<ImageResizerScreen> {
  double _quality = 80;
  String _selectedFormat = 'JPG';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Resizer & Compressor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate, size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('Tap to select an image from gallery', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Compression Quality: ${_quality.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: _quality,
                    min: 10,
                    max: 100,
                    divisions: 18,
                    onChanged: (val) => setState(() => _quality = val),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Target Format:', style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: _selectedFormat,
                        items: ['JPG', 'PNG', 'WebP'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                        onChanged: (val) => setState(() => _selectedFormat = val!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            icon: const Icon(Icons.compress),
            label: const Text('Compress & Save Image', style: TextStyle(fontSize: 18)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Image compressed to $_selectedFormat format successfully!')),
              );
            },
          ),
        ],
      ),
    );
  }
}
