import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

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
