import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../student_utils/student_models.dart';

final schoolNameProvider = StateProvider<String>((ref) => 'Dhaka Government High School');
final examTitleProvider = StateProvider<String>((ref) => 'Annual Examination - 2025');
final subjectClassProvider = StateProvider<String>((ref) => 'Subject: Mathematics | Class: IX');
final examTimeMarksProvider = StateProvider<String>((ref) => 'Time: 3 Hours | Total Marks: 100');

class QuestionPaperGeneratorScreen extends ConsumerStatefulWidget {
  const QuestionPaperGeneratorScreen({super.key});

  @override
  ConsumerState<QuestionPaperGeneratorScreen> createState() => _QuestionPaperGeneratorScreenState();
}

class _QuestionPaperGeneratorScreenState extends ConsumerState<QuestionPaperGeneratorScreen> {
  final List<String> _questions = [
    '1. Solve the quadratic equation: x² - 5x + 6 = 0. (Marks: 5)',
    '2. Define Pythagoras theorem and prove it with diagram. (Marks: 10)',
    '3. Find the area of a circle with radius r = 7 cm. (Marks: 5)',
  ];

  final TextEditingController _qController = TextEditingController();

  void _addQuestion() {
    if (_qController.text.trim().isEmpty) return;
    setState(() {
      _questions.add('${_questions.length + 1}. ${_qController.text.trim()}');
      _qController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final schoolName = ref.watch(schoolNameProvider);
    final examTitle = ref.watch(examTitleProvider);
    final subjectClass = ref.watch(subjectClassProvider);
    final timeMarks = ref.watch(examTimeMarksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Question Paper Generator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          studentHero('Question Paper Maker', 'Design, format and print exam question papers for schools & colleges', Colors.blue, Icons.description),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: schoolName,
                    decoration: const InputDecoration(labelText: 'Institution Name', border: OutlineInputBorder()),
                    onChanged: (v) => ref.read(schoolNameProvider.notifier).state = v,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: examTitle,
                    decoration: const InputDecoration(labelText: 'Exam Title', border: OutlineInputBorder()),
                    onChanged: (v) => ref.read(examTitleProvider.notifier).state = v,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: subjectClass,
                          decoration: const InputDecoration(labelText: 'Subject & Class', border: OutlineInputBorder()),
                          onChanged: (v) => ref.read(subjectClassProvider.notifier).state = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: timeMarks,
                          decoration: const InputDecoration(labelText: 'Time & Marks', border: OutlineInputBorder()),
                          onChanged: (v) => ref.read(examTimeMarksProvider.notifier).state = v,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _qController,
                  decoration: const InputDecoration(
                    labelText: 'Type New Question',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                icon: const Icon(Icons.add),
                onPressed: _addQuestion,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(schoolName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(examTitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(subjectClass, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text(timeMarks, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                  const Divider(thickness: 1.5, color: Colors.black54),
                  const SizedBox(height: 8),
                  ..._questions.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final q = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text(q, style: const TextStyle(color: Colors.black, fontSize: 14))),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                            onPressed: () => setState(() => _questions.removeAt(idx)),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.print),
            label: const Text('Print / Save Question Paper PDF', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Question paper generated & sent to printer/PDF!'),
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
