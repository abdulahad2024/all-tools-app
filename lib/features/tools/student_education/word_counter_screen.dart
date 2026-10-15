import 'package:flutter/material.dart';

class WordCounterScreen extends StatefulWidget {
  const WordCounterScreen({super.key});

  @override
  State<WordCounterScreen> createState() => _WordCounterScreenState();
}

class _WordCounterScreenState extends State<WordCounterScreen> {
  final TextEditingController _textController = TextEditingController();

  int _words = 0;
  int _characters = 0;
  int _sentences = 0;
  int _readingTimeMin = 0;

  void _analyzeText(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _words = 0;
        _characters = 0;
        _sentences = 0;
        _readingTimeMin = 0;
      });
      return;
    }

    final wordList = trimmed.split(RegExp(r'\s+'));
    final sentenceList = trimmed.split(RegExp(r'[.!?]+')).where((s) => s.trim().isNotEmpty).toList();

    setState(() {
      _words = wordList.length;
      _characters = text.length;
      _sentences = sentenceList.length;
      _readingTimeMin = (_words / 200).ceil();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word & Character Counter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildStatTile('Words', '$_words', Colors.blue),
                _buildStatTile('Chars', '$_characters', Colors.green),
                _buildStatTile('Sentences', '$_sentences', Colors.orange),
                _buildStatTile('Read Time', '$_readingTimeMin m', Colors.purple),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type or paste your document text here...',
                ),
                onChanged: _analyzeText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String val, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              Text(val, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
