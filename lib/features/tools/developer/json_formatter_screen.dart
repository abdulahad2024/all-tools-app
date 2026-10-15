import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonFormatterScreen extends StatefulWidget {
  const JsonFormatterScreen({super.key});

  @override
  State<JsonFormatterScreen> createState() => _JsonFormatterScreenState();
}

class _JsonFormatterScreenState extends State<JsonFormatterScreen> {
  final TextEditingController _inputController = TextEditingController(
    text: '{"name":"All Tools","version":1.0,"features":["Math","PDF","Dev"]}',
  );
  String _output = '';
  String _status = '';

  void _formatJson() {
    try {
      final decoded = json.decode(_inputController.text);
      final encoder = const JsonEncoder.withIndent('  ');
      setState(() {
        _output = encoder.convert(decoded);
        _status = 'Valid JSON formatted!';
      });
    } catch (e) {
      setState(() {
        _output = '';
        _status = 'Invalid JSON: $e';
      });
    }
  }

  void _minifyJson() {
    try {
      final decoded = json.decode(_inputController.text);
      setState(() {
        _output = json.encode(decoded);
        _status = 'JSON Minified!';
      });
    } catch (e) {
      setState(() {
        _output = '';
        _status = 'Invalid JSON: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSON Formatter & Validator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Input Raw JSON',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.format_align_left),
                    label: const Text('Prettify'),
                    onPressed: _formatJson,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.compress),
                    label: const Text('Minify'),
                    onPressed: _minifyJson,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_status.isNotEmpty)
              Text(_status, style: TextStyle(color: _status.startsWith('Valid') || _status.contains('Minified') ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: Stack(
                children: [
                  TextField(
                    controller: TextEditingController(text: _output),
                    readOnly: true,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Formatted Output',
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _output));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Output copied!')));
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
