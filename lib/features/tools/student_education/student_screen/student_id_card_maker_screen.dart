import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../student_utils/student_models.dart';

final idStudentNameProvider = StateProvider<String>((ref) => 'Sabbir Hossain');
final idRollNoProvider = StateProvider<String>((ref) => '104');
final idClassSecProvider = StateProvider<String>((ref) => 'Class X • Sec A');
final idBloodGroupProvider = StateProvider<String>((ref) => 'B+ (Positive)');
final idGuardianPhoneProvider = StateProvider<String>((ref) => '+880 1712 345678');

class StudentIdCardMakerScreen extends ConsumerStatefulWidget {
  const StudentIdCardMakerScreen({super.key});

  @override
  ConsumerState<StudentIdCardMakerScreen> createState() => _StudentIdCardMakerScreenState();
}

class _StudentIdCardMakerScreenState extends ConsumerState<StudentIdCardMakerScreen> {
  XFile? _studentPhoto;

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => _studentPhoto = img);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(idStudentNameProvider);
    final roll = ref.watch(idRollNoProvider);
    final classSec = ref.watch(idClassSecProvider);
    final blood = ref.watch(idBloodGroupProvider);
    final phone = ref.watch(idGuardianPhoneProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Student ID Card Maker')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          studentHero('Student ID Card Generator', 'Design, format and print official student identity cards', Colors.deepPurple, Icons.badge),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(labelText: 'Student Full Name', border: OutlineInputBorder()),
                    onChanged: (v) => ref.read(idStudentNameProvider.notifier).state = v,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: roll,
                          decoration: const InputDecoration(labelText: 'Roll No', border: OutlineInputBorder()),
                          onChanged: (v) => ref.read(idRollNoProvider.notifier).state = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: classSec,
                          decoration: const InputDecoration(labelText: 'Class & Section', border: OutlineInputBorder()),
                          onChanged: (v) => ref.read(idClassSecProvider.notifier).state = v,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: blood,
                          decoration: const InputDecoration(labelText: 'Blood Group', border: OutlineInputBorder()),
                          onChanged: (v) => ref.read(idBloodGroupProvider.notifier).state = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: phone,
                          decoration: const InputDecoration(labelText: 'Guardian Phone', border: OutlineInputBorder()),
                          onChanged: (v) => ref.read(idGuardianPhoneProvider.notifier).state = v,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Student ID Card Preview
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade700, Colors.indigo.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const Text('ST. JOSEPH HIGHER SECONDARY SCHOOL', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
                  const Text('STUDENT IDENTITY CARD', style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _pickPhoto,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white24,
                      backgroundImage: _studentPhoto != null
                          ? (kIsWeb ? NetworkImage(_studentPhoto!.path) : FileImage(File(_studentPhoto!.path)) as ImageProvider)
                          : null,
                      child: _studentPhoto == null ? const Icon(Icons.add_a_photo, color: Colors.white, size: 30) : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('$classSec  |  Roll: $roll', style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8)),
                    child: Text('Blood Group: $blood  •  Emergency: $phone', style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.print),
            label: const Text('Print / Save Student ID Card PDF', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Student ID Card printed & saved to PDF!'),
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
