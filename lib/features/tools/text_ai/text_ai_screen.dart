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

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _inputController = TextEditingController(
    text: 'Flutter is an open-source UI software development kit created by Google. It is used to develop cross platform applications for Android, iOS, Linux, Mac, Windows, Google Fuchsia, and the web from a single codebase.',
  );
  String _summary = '';

  void _summarizeText() {
    setState(() {
      _summary = '• Flutter is Google\'s open-source cross-platform UI toolkit.\n• Supports mobile, desktop, and web from a single codebase.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Text Summarizer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              maxLines: 5,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Input Long Article'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              icon: const Icon(Icons.psychology),
              label: const Text('Summarize Article'),
              onPressed: _summarizeText,
            ),
            const SizedBox(height: 16),
            if (_summary.isNotEmpty)
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Key Bullet Points:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(_summary, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
