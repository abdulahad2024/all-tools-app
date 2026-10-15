import 'package:flutter/material.dart';

class StudentGpaScreen extends StatefulWidget {
  const StudentGpaScreen({super.key});

  @override
  State<StudentGpaScreen> createState() => _StudentGpaScreenState();
}

class _StudentGpaScreenState extends State<StudentGpaScreen> {
  final List<Map<String, dynamic>> _courses = [
    {'name': 'Maths', 'grade': 4.0, 'credit': 3.0},
    {'name': 'Physics', 'grade': 3.75, 'credit': 3.0},
    {'name': 'Programming', 'grade': 4.0, 'credit': 4.0},
  ];

  double get _calculatedGpa {
    double totalPoints = 0;
    double totalCredits = 0;
    for (var c in _courses) {
      totalPoints += (c['grade'] as double) * (c['credit'] as double);
      totalCredits += (c['credit'] as double);
    }
    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  void _addCourse() {
    setState(() {
      _courses.add({'name': 'Course ${_courses.length + 1}', 'grade': 3.5, 'credit': 3.0});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPA / CGPA Calculator')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Semester GPA:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                  _calculatedGpa.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(course['name']),
                    subtitle: Text('Credits: ${course['credit']} | Grade Point: ${course['grade']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _courses.removeAt(index)),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              icon: const Icon(Icons.add),
              label: const Text('Add Course'),
              onPressed: _addCourse,
            ),
          ),
        ],
      ),
    );
  }
}
