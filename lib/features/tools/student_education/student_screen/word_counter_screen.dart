import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../student_provider/student_tools_provider.dart';

class WordCounterScreen extends ConsumerWidget {
  const WordCounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(wordCounterTextProvider);

    int words = 0;
    int characters = 0;
    int sentences = 0;
    int readingTimeMin = 0;

    final trimmed = text.trim();
    if (trimmed.isNotEmpty) {
      words = trimmed.split(RegExp(r'\s+')).length;
      characters = text.length;
      sentences = trimmed.split(RegExp(r'[.!?]+')).where((s) => s.trim().isNotEmpty).length;
      readingTimeMin = (words / 200).ceil();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Word & Character Counter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildStatTile('Words', '$words', Colors.blue),
                _buildStatTile('Chars', '$characters', Colors.green),
                _buildStatTile('Sentences', '$sentences', Colors.orange),
                _buildStatTile('Read Time', '$readingTimeMin m', Colors.purple),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextFormField(
                initialValue: text,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type or paste your document text here...',
                ),
                onChanged: (val) => ref.read(wordCounterTextProvider.notifier).state = val,
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
