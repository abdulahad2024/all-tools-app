import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dev_provider/dev_tools_provider.dart';
import '../dev_utils/dev_models.dart';

class JsonToModelScreen extends ConsumerWidget {
  const JsonToModelScreen({super.key});

  void _generateModel(WidgetRef ref, String rawJson, String language) {
    try {
      final decoded = json.decode(rawJson) as Map<String, dynamic>;
      StringBuffer buffer = StringBuffer();

      if (language == 'Dart') {
        buffer.writeln('class AutoModel {');
        decoded.forEach((key, value) {
          String type = 'dynamic';
          if (value is int) {
            type = 'int';
          } else if (value is double) {
            type = 'double';
          } else if (value is String) {
            type = 'String';
          } else if (value is bool) {
            type = 'bool';
          }
          buffer.writeln('  final $type $key;');
        });
        buffer.writeln('\n  AutoModel({');
        decoded.forEach((key, _) => buffer.writeln('    required this.$key,'));
        buffer.writeln('  });\n}');
      } else {
        buffer.writeln('data class AutoModel(');
        decoded.forEach((key, value) {
          String type = 'Any';
          if (value is int) {
            type = 'Int';
          } else if (value is double) {
            type = 'Double';
          } else if (value is String) {
            type = 'String';
          } else if (value is bool) {
            type = 'Boolean';
          }
          buffer.writeln('    val $key: $type,');
        });
        buffer.writeln(')');
      }

      ref.read(generatedModelCodeProvider.notifier).state = buffer.toString();
    } catch (e) {
      ref.read(generatedModelCodeProvider.notifier).state = 'Error generating model class: Invalid JSON input.';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawJson = ref.watch(rawJsonInputProvider);
    final language = ref.watch(modelTargetLanguageProvider);
    final generatedCode = ref.watch(generatedModelCodeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('JSON to Model Generator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          devHero('JSON to Class Generator', 'Convert JSON payloads to typed Dart & Kotlin data model classes', Colors.deepPurple, Icons.integration_instructions),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Target Language: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              DropdownButton<String>(
                value: language,
                items: ['Dart', 'Kotlin'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: (val) {
                  if (val != null) ref.read(modelTargetLanguageProvider.notifier).state = val;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _generateModel(ref, rawJson, language),
                child: const Text('Generate Class'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: rawJson,
            maxLines: 4,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Sample JSON'),
            onChanged: (val) => ref.read(rawJsonInputProvider.notifier).state = val,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  TextFormField(
                    key: ValueKey(generatedCode),
                    initialValue: generatedCode,
                    readOnly: true,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Generated $language Class Code',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.blue),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: generatedCode));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Model class copied!')));
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
