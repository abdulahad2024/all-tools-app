import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dev_provider/dev_tools_provider.dart';
import '../dev_utils/dev_models.dart';

class JsonFormatterScreen extends ConsumerWidget {
  const JsonFormatterScreen({super.key});

  void _formatJson(WidgetRef ref, String raw) {
    try {
      final decoded = json.decode(raw);
      final encoder = const JsonEncoder.withIndent('  ');
      ref.read(formattedJsonOutputProvider.notifier).state = encoder.convert(decoded);
      ref.read(jsonStatusProvider.notifier).state = 'Valid JSON formatted!';
    } catch (e) {
      ref.read(formattedJsonOutputProvider.notifier).state = '';
      ref.read(jsonStatusProvider.notifier).state = 'Invalid JSON: $e';
    }
  }

  void _minifyJson(WidgetRef ref, String raw) {
    try {
      final decoded = json.decode(raw);
      ref.read(formattedJsonOutputProvider.notifier).state = json.encode(decoded);
      ref.read(jsonStatusProvider.notifier).state = 'JSON Minified!';
    } catch (e) {
      ref.read(formattedJsonOutputProvider.notifier).state = '';
      ref.read(jsonStatusProvider.notifier).state = 'Invalid JSON: $e';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawInput = ref.watch(rawJsonInputProvider);
    final output = ref.watch(formattedJsonOutputProvider);
    final status = ref.watch(jsonStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('JSON Formatter & Validator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          devHero('JSON & Code Formatter', 'Format, minify, validate and beautify JSON payloads', Colors.indigo, Icons.data_object),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: rawInput,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Input Raw JSON',
            ),
            onChanged: (val) => ref.read(rawJsonInputProvider.notifier).state = val,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.format_align_left),
                  label: const Text('Prettify'),
                  onPressed: () => _formatJson(ref, rawInput),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.compress),
                  label: const Text('Minify'),
                  onPressed: () => _minifyJson(ref, rawInput),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (status.isNotEmpty)
            Text(
              status,
              style: TextStyle(
                color: status.startsWith('Valid') || status.contains('Minified') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    key: ValueKey(output),
                    initialValue: output,
                    readOnly: true,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Formatted Output',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.blue),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: output));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Output copied to clipboard!')));
                    },
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
