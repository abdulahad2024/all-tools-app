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

  String get _hexCode => '#${_currentColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  String get _rgbCode => 'RGB(${_currentColor.r * 255}, ${_currentColor.g * 255}, ${_currentColor.b * 255})';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Color Picker from Image')),
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
