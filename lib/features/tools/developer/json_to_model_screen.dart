import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonToModelScreen extends StatefulWidget {
  const JsonToModelScreen({super.key});

  @override
  State<JsonToModelScreen> createState() => _JsonToModelScreenState();
}

class _JsonToModelScreenState extends State<JsonToModelScreen> {
  final TextEditingController _jsonController = TextEditingController(
    text: '{"id": 1, "title": "Dart Model", "isActive": true, "price": 49.99}',
  );
  String _generatedCode = '';
  String _language = 'Dart';

  void _generateModel() {
    try {
      final decoded = json.decode(_jsonController.text) as Map<String, dynamic>;
      StringBuffer buffer = StringBuffer();

      if (_language == 'Dart') {
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

      setState(() => _generatedCode = buffer.toString());
    } catch (e) {
      setState(() => _generatedCode = 'Error generating model: Invalid JSON input.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSON to Model Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Target Language: ', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: _language,
                  items: ['Dart', 'Kotlin'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                  onChanged: (val) => setState(() => _language = val!),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _generateModel,
                  child: const Text('Generate Class'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _jsonController,
              maxLines: 4,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Sample JSON'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: _generatedCode),
                readOnly: true,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Generated $_language Model',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _generatedCode));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Model class copied!')));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
