import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../student_utils/student_models.dart';

final appTypeProvider = StateProvider<String>((ref) => 'Leave Application (ছুটির আবেদন)');
final appStudentNameProvider = StateProvider<String>((ref) => 'Mahmudul Hasan');
final appReasonProvider = StateProvider<String>((ref) => 'Sickness / Fever');
final appDaysProvider = StateProvider<String>((ref) => '3 Days (26 March to 28 March)');

class LeaveApplicationGeneratorScreen extends ConsumerWidget {
  const LeaveApplicationGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appType = ref.watch(appTypeProvider);
    final studentName = ref.watch(appStudentNameProvider);
    final reason = ref.watch(appReasonProvider);
    final days = ref.watch(appDaysProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Application & Testimonial Maker')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          studentHero('Application Generator', 'Format official leave applications, fee waivers & testimonials for schools', Colors.indigo, Icons.edit_note),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: appType,
                    decoration: const InputDecoration(labelText: 'Application Category', border: OutlineInputBorder()),
                    items: [
                      'Leave Application (ছুটির আবেদন)',
                      'Fee Waiver Application (ফি মওকুফের আবেদন)',
                      'Testimonial Request (প্রশংসাপত্রের আবেদন)',
                    ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) {
                      if (v != null) ref.read(appTypeProvider.notifier).state = v;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: studentName,
                    decoration: const InputDecoration(labelText: 'Student Name', border: OutlineInputBorder()),
                    onChanged: (v) => ref.read(appStudentNameProvider.notifier).state = v,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: reason,
                    decoration: const InputDecoration(labelText: 'Reason for Application', border: OutlineInputBorder()),
                    onChanged: (v) => ref.read(appReasonProvider.notifier).state = v,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: days,
                    decoration: const InputDecoration(labelText: 'Duration / Dates', border: OutlineInputBorder()),
                    onChanged: (v) => ref.read(appDaysProvider.notifier).state = v,
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
                  const Text('Date: 26 March 2025', style: TextStyle(color: Colors.black87, fontSize: 13)),
                  const Text('To,', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  const Text('The Principal / Headmaster,', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  const Text('Government Model School & College, Dhaka.', style: TextStyle(color: Colors.black87)),
                  const SizedBox(height: 12),
                  Text('Subject: Application for $reason.', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
                  const SizedBox(height: 12),
                  const Text('Respected Sir,', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    'I beg most respectfully to state that I am a student of Class X in your esteemed institution. Due to $reason, I am unable to attend classes for $days.\n\nI, therefore, pray and hope that you would be kind enough to grant me leave for those days only.',
                    style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Text('Yours obediently,\n$studentName\nClass: X | Roll: 12', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, height: 1.4)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.print),
            label: const Text('Print / Export Application PDF', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Application document saved & ready to print!'),
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
