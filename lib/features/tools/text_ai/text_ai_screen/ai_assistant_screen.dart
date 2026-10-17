import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../text_ai_provider/text_ai_tools_provider.dart';
import '../text_ai_utils/text_ai_models.dart';

class AiAssistantScreen extends ConsumerWidget {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleInput = ref.watch(aiArticleInputProvider);
    final summaryOutput = ref.watch(aiSummaryOutputProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Text Summarizer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          textAiHero('AI Text Summarizer & Assistant', 'Summarize long articles, rewrite sentences and check tone', Colors.purple, Icons.psychology),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: articleInput,
            maxLines: 5,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Input Long Article'),
            onChanged: (val) => ref.read(aiArticleInputProvider.notifier).state = val,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.psychology),
            label: const Text('Summarize Article', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: () {
              ref.read(aiSummaryOutputProvider.notifier).state = '• Flutter is Google\'s open-source cross-platform UI toolkit.\n• Supports mobile, desktop, and web from a single codebase.';
            },
          ),
          const SizedBox(height: 16),
          if (summaryOutput.isNotEmpty)
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Key Bullet Points:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(summaryOutput, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
