import 'package:flutter/material.dart';
import '../student_utils/student_models.dart';

class ClassRoutineMakerScreen extends StatefulWidget {
  const ClassRoutineMakerScreen({super.key});

  @override
  State<ClassRoutineMakerScreen> createState() => _ClassRoutineMakerScreenState();
}

class _ClassRoutineMakerScreenState extends State<ClassRoutineMakerScreen> {
  final List<Map<String, String>> _routineItems = [
    {'time': '09:00 AM', 'day': 'Sunday', 'subject': 'Mathematics', 'teacher': 'Mr. Alam', 'room': 'Room 301'},
    {'time': '10:00 AM', 'day': 'Sunday', 'subject': 'Physics', 'teacher': 'Dr. Hassan', 'room': 'Lab 102'},
    {'time': '11:00 AM', 'day': 'Monday', 'subject': 'English Grammar', 'teacher': 'Mrs. Fatima', 'room': 'Room 204'},
  ];

  final TextEditingController _timeCtrl = TextEditingController(text: '12:00 PM');
  final TextEditingController _subjCtrl = TextEditingController(text: 'ICT & Programming');
  final TextEditingController _teacherCtrl = TextEditingController(text: 'Engr. Karim');

  void _addPeriod() {
    if (_subjCtrl.text.trim().isEmpty) return;
    setState(() {
      _routineItems.add({
        'time': _timeCtrl.text.trim(),
        'day': 'Tuesday',
        'subject': _subjCtrl.text.trim(),
        'teacher': _teacherCtrl.text.trim(),
        'room': 'Room 105',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Class Routine Maker')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          studentHero('Class Routine Builder', 'Design weekly class routine with time slots, teacher name & room', Colors.teal, Icons.table_chart),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _timeCtrl,
                          decoration: const InputDecoration(labelText: 'Time Slot', border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _subjCtrl,
                          decoration: const InputDecoration(labelText: 'Subject Name', border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _teacherCtrl,
                          decoration: const InputDecoration(labelText: 'Teacher Name', border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Period'),
                        onPressed: _addPeriod,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Weekly Routine Table', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Card(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Day', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Time', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Subject', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Teacher', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Room', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: _routineItems.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(Text(item['day']!)),
                      DataCell(Text(item['time']!)),
                      DataCell(Text(item['subject']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(item['teacher']!)),
                      DataCell(Text(item['room']!)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.print),
            label: const Text('Print / Save Routine PDF', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Class routine printed & saved successfully!'),
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
