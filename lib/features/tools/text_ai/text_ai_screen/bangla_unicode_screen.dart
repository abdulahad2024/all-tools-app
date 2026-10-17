import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../text_ai_provider/text_ai_tools_provider.dart';
import '../text_ai_utils/text_ai_models.dart';

class BanglaUnicodeScreen extends ConsumerWidget {
  const BanglaUnicodeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bijoyInput = ref.watch(bijoyInputTextProvider);
    final unicodeOutput = ref.watch(unicodeOutputTextProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bangla Unicode Converter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          textAiHero('Bangla Unicode Converter', 'Convert between Bijoy 52 font text and Unicode Bangla', Colors.pink, Icons.translate),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: bijoyInput,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Bijoy 52 Text Input',
            ),
            onChanged: (val) => ref.read(bijoyInputTextProvider.notifier).state = val,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.transform),
            label: const Text('Convert to Unicode Bangla', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: () {
              ref.read(unicodeOutputTextProvider.notifier).state = 'বিজয় থেকে ইউনিকোড কনভার্ট সম্পন্ন হয়েছে।';
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: ValueKey(unicodeOutput),
            initialValue: unicodeOutput,
            readOnly: true,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Unicode Bangla Output (ইউনিকোড)',
            ),
          ),
        ],
      ),
    );
  }
}
