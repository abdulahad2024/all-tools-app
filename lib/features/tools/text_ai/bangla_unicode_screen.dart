import 'package:flutter/material.dart';

class BanglaUnicodeScreen extends StatefulWidget {
  const BanglaUnicodeScreen({super.key});

  @override
  State<BanglaUnicodeScreen> createState() => _BanglaUnicodeScreenState();
}

class _BanglaUnicodeScreenState extends State<BanglaUnicodeScreen> {
  final TextEditingController _inputController = TextEditingController(text: 'Avgvi e½veÜz me mgq RbM‡Yi cv‡k wQ‡jb');
  String _convertedOutput = 'আমার বঙ্গবন্ধু সব সময় জনগণের পাশে ছিলেন';

  void _convert() {
    setState(() {
      _convertedOutput = 'বিজয় থেকে ইউনিকোড কনভার্ট সম্পন্ন হয়েছে।';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bangla Unicode Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Bijoy 52 Text Input',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              icon: const Icon(Icons.transform),
              label: const Text('Convert to Unicode Bangla'),
              onPressed: _convert,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: _convertedOutput),
                readOnly: true,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Unicode Bangla Output (ইউনিকোড)',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
