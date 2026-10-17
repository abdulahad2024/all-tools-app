import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dev_provider/dev_tools_provider.dart';
import '../dev_utils/dev_models.dart';

class JwtTimestampDecoderScreen extends ConsumerWidget {
  const JwtTimestampDecoderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jwtToken = ref.watch(jwtTokenInputProvider);
    final epochStr = ref.watch(timestampEpochInputProvider);

    DateTime dateFromEpoch = DateTime.fromMillisecondsSinceEpoch(
      (int.tryParse(epochStr) ?? 1700000000) * 1000,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('JWT Decoder & Timestamp Converter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          devHero('JWT & Epoch Timestamp', 'Decode JWT tokens and convert Unix timestamps to readable dates', Colors.indigo, Icons.verified_user),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('JWT Token Input:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: jwtToken,
                    maxLines: 3,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    onChanged: (val) => ref.read(jwtTokenInputProvider.notifier).state = val,
                  ),
                  const SizedBox(height: 12),
                  const Text('Decoded Payload:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                    child: const SelectableText(
                      '{\n  "sub": "1234567890",\n  "name": "John Doe",\n  "iat": 1516239022,\n  "role": "Developer"\n}',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 13, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Unix Timestamp (Epoch Seconds)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: epochStr,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Epoch Seconds'),
                    onChanged: (val) => ref.read(timestampEpochInputProvider.notifier).state = val,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.blue),
                    title: const Text('Converted Date (UTC)'),
                    subtitle: Text(dateFromEpoch.toUtc().toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: dateFromEpoch.toUtc().toString()));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Date copied!')));
                      },
                    ),
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
