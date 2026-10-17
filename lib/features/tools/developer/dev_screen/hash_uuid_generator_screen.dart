import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../dev_provider/dev_tools_provider.dart';
import '../dev_utils/dev_models.dart';

class HashUuidGeneratorScreen extends ConsumerWidget {
  const HashUuidGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputStr = ref.watch(hashInputStringProvider);
    final currentUuid = ref.watch(generatedUuidProvider);

    final bytes = utf8.encode(inputStr);
    final md5Hash = md5.convert(bytes).toString();
    final sha1Hash = sha1.convert(bytes).toString();
    final sha256Hash = sha256.convert(bytes).toString();
    final base64Encoded = base64.encode(bytes);

    return Scaffold(
      appBar: AppBar(title: const Text('Hash, UUID & Base64 Encoder')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          devHero('Cryptographic Hashes & UUID', 'Generate MD5, SHA-1, SHA-256 hashes and random v4 UUIDs', Colors.cyan.shade800, Icons.fingerprint),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: inputStr,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Input String'),
            onChanged: (val) => ref.read(hashInputStringProvider.notifier).state = val,
          ),
          const SizedBox(height: 16),
          _buildHashCard(context, 'MD5 Hash', md5Hash),
          _buildHashCard(context, 'SHA-1 Hash', sha1Hash),
          _buildHashCard(context, 'SHA-256 Hash', sha256Hash),
          _buildHashCard(context, 'Base64 Encoded', base64Encoded),
          const Divider(height: 32),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.cyan.shade800,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Generate New UUID v4', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: () {
              ref.read(generatedUuidProvider.notifier).state = const Uuid().v4();
            },
          ),
          const SizedBox(height: 12),
          _buildHashCard(context, 'UUID v4', currentUuid.isEmpty ? const Uuid().v4() : currentUuid),
        ],
      ),
    );
  }

  Widget _buildHashCard(BuildContext context, String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: SelectableText(value, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
        trailing: IconButton(
          icon: const Icon(Icons.copy, size: 20, color: Colors.blue),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title copied!')));
          },
        ),
      ),
    );
  }
}
