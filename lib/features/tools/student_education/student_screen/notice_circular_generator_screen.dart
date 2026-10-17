import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../student_utils/student_models.dart';

final noticeTitleProvider = StateProvider<String>((ref) => 'NOTICE: Eid-ul-Fitr & Summer Vacation');
final noticeInstProvider = StateProvider<String>((ref) => 'Dhaka City College');
final noticeBodyProvider = StateProvider<String>((ref) => 'This is to inform all students, faculty members and administrative staff that the college will remain closed from March 28 to April 10 on account of Eid-ul-Fitr and Summer Vacation. Classes will resume on April 11.');

class NoticeCircularGeneratorScreen extends ConsumerWidget {
  const NoticeCircularGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(noticeTitleProvider);
    final inst = ref.watch(noticeInstProvider);
    final body = ref.watch(noticeBodyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notice & Circular Maker')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          studentHero('Notice & Circular Maker', 'Create, format and publish official academic notices & circulars', Colors.red, Icons.campaign),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: inst,
                    decoration: const InputDecoration(labelText: 'Institution Name', border: OutlineInputBorder()),
                    onChanged: (v) => ref.read(noticeInstProvider.notifier).state = v,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: title,
                    decoration: const InputDecoration(labelText: 'Notice Title / Headline', border: OutlineInputBorder()),
                    onChanged: (v) => ref.read(noticeTitleProvider.notifier).state = v,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: body,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Notice Content Paragraphs', border: OutlineInputBorder()),
                    onChanged: (v) => ref.read(noticeBodyProvider.notifier).state = v,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text(inst, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black))),
                  const Center(child: Text('OFFICIAL NOTICE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red))),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ref: DCC/NOT/2025/104', style: TextStyle(fontSize: 12, color: Colors.black87)),
                      Text('Date: 25 March 2025', style: TextStyle(fontSize: 12, color: Colors.black87)),
                    ],
                  ),
                  const Divider(thickness: 1.5, color: Colors.black54),
                  const SizedBox(height: 8),
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 12),
                  Text(body, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5)),
                  const SizedBox(height: 32),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Dr. K. Ahmed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                        Text('Principal / Authority', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.print),
            label: const Text('Print / Export Notice PDF', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notice exported and saved to PDF!'),
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
