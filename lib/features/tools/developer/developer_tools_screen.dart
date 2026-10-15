import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

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
          if (value is int) type = 'int';
          else if (value is double) type = 'double';
          else if (value is String) type = 'String';
          else if (value is bool) type = 'bool';
          buffer.writeln('  final $type $key;');
        });
        buffer.writeln('\n  AutoModel({');
        decoded.forEach((key, _) => buffer.writeln('    required this.$key,'));
        buffer.writeln('  });\n}');
      } else {
        buffer.writeln('data class AutoModel(');
        decoded.forEach((key, value) {
          String type = 'Any';
          if (value is int) type = 'Int';
          else if (value is double) type = 'Double';
          else if (value is String) type = 'String';
          else if (value is bool) type = 'Boolean';
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

class HashGeneratorScreen extends StatefulWidget {
  const HashGeneratorScreen({super.key});

  @override
  State<HashGeneratorScreen> createState() => _HashGeneratorScreenState();
}

class _HashGeneratorScreenState extends State<HashGeneratorScreen> {
  final TextEditingController _inputController = TextEditingController(text: 'All Tools App');
  String _md5 = '';
  String _sha1 = '';
  String _sha256 = '';
  String _uuid = '';

  void _generateHashes() {
    final bytes = utf8.encode(_inputController.text);
    setState(() {
      _md5 = md5.convert(bytes).toString();
      _sha1 = sha1.convert(bytes).toString();
      _sha256 = sha256.convert(bytes).toString();
    });
  }

  void _generateUuid() {
    setState(() {
      _uuid = const Uuid().v4();
    });
  }

  @override
  void initState() {
    super.initState();
    _generateHashes();
    _generateUuid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hash & UUID Generator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _inputController,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Input String'),
            onChanged: (_) => _generateHashes(),
          ),
          const SizedBox(height: 16),
          _buildHashCard('MD5 Hash', _md5),
          _buildHashCard('SHA-1 Hash', _sha1),
          _buildHashCard('SHA-256 Hash', _sha256),
          const Divider(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Generate Random UUID v4'),
            onPressed: _generateUuid,
          ),
          const SizedBox(height: 12),
          _buildHashCard('UUID v4', _uuid),
        ],
      ),
    );
  }

  Widget _buildHashCard(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(value, style: const TextStyle(fontFamily: 'monospace')),
        trailing: IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title copied!')));
          },
        ),
      ),
    );
  }
}
