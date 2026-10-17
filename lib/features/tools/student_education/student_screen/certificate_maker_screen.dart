import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../student_utils/student_models.dart';

final certTitleProvider = StateProvider<String>((ref) => 'CERTIFICATE OF EXCELLENCE');
final recipientNameProvider = StateProvider<String>((ref) => 'Tanvir Ahmed');
final certDescriptionProvider = StateProvider<String>((ref) => 'For outstanding performance in the Annual Science & Math Olympiad 2025.');
final certInstNameProvider = StateProvider<String>((ref) => 'National Science Academy');

class CertificateMakerScreen extends ConsumerWidget {
  const CertificateMakerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certTitle = ref.watch(certTitleProvider);
    final recipient = ref.watch(recipientNameProvider);
    final description = ref.watch(certDescriptionProvider);
    final instName = ref.watch(certInstNameProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Certificate Maker')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          studentHero('Certificate Generator', 'Design, format and print official certificates of excellence & completion', Colors.amber.shade800, Icons.card_membership),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: certTitle,
                    decoration: const InputDecoration(labelText: 'Certificate Title', border: OutlineInputBorder()),
                    onChanged: (v) => ref.read(certTitleProvider.notifier).state = v,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: recipient,
                    decoration: const InputDecoration(labelText: 'Recipient Student Name', border: OutlineInputBorder()),
                    onChanged: (v) => ref.read(recipientNameProvider.notifier).state = v,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: description,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Achievement Reason / Course', border: OutlineInputBorder()),
                    onChanged: (v) => ref.read(certDescriptionProvider.notifier).state = v,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: instName,
                    decoration: const InputDecoration(labelText: 'Issuing Institution Name', border: OutlineInputBorder()),
                    onChanged: (v) => ref.read(certInstNameProvider.notifier).state = v,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Live Certificate Preview
          Card(
            elevation: 8,
            color: const Color(0xFFFFFDF5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.amber, width: 4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium, size: 54, color: Colors.amber),
                  const SizedBox(height: 8),
                  Text(instName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 12),
                  Text(certTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber, letterSpacing: 1.5)),
                  const SizedBox(height: 12),
                  const Text('PROUDLY PRESENTED TO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text(recipient, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo)),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('15 MMMM 2025', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
                          Divider(thickness: 1),
                          Text('Date of Issue', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Prof. M. Rahman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
                          Divider(thickness: 1),
                          Text('Principal Signature', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.amber.shade800,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.print),
            label: const Text('Print / Save Certificate PDF', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Certificate generated and saved to PDF!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
