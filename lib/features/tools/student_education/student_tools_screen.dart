import 'dart:async';
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

class WordCounterScreen extends StatefulWidget {
  const WordCounterScreen({super.key});

  @override
  State<WordCounterScreen> createState() => _WordCounterScreenState();
}

class _WordCounterScreenState extends State<WordCounterScreen> {
  final TextEditingController _textController = TextEditingController();

  int _words = 0;
  int _characters = 0;
  int _sentences = 0;
  int _readingTimeMin = 0;

  void _analyzeText(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _words = 0;
        _characters = 0;
        _sentences = 0;
        _readingTimeMin = 0;
      });
      return;
    }

    final wordList = trimmed.split(RegExp(r'\s+'));
    final sentenceList = trimmed.split(RegExp(r'[.!?]+')).where((s) => s.trim().isNotEmpty).toList();

    setState(() {
      _words = wordList.length;
      _characters = text.length;
      _sentences = sentenceList.length;
      _readingTimeMin = (_words / 200).ceil();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word & Character Counter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildStatTile('Words', '$_words', Colors.blue),
                _buildStatTile('Chars', '$_characters', Colors.green),
                _buildStatTile('Sentences', '$_sentences', Colors.orange),
                _buildStatTile('Read Time', '$_readingTimeMin m', Colors.purple),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type or paste your document text here...',
                ),
                onChanged: _analyzeText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String val, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              Text(val, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class PomodoroTimerScreen extends StatefulWidget {
  const PomodoroTimerScreen({super.key});

  @override
  State<PomodoroTimerScreen> createState() => _PomodoroTimerScreenState();
}

class _PomodoroTimerScreenState extends State<PomodoroTimerScreen> {
  static const int _workSeconds = 25 * 60;
  int _secondsLeft = _workSeconds;
  bool _isRunning = false;
  Timer? _timer;

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsLeft > 0) {
          setState(() => _secondsLeft--);
        } else {
          _timer?.cancel();
          setState(() => _isRunning = false);
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsLeft = _workSeconds;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _secondsLeft ~/ 60;
    int seconds = _secondsLeft % 60;
    String timeStr = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro Study Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Center(
                child: Text(
                  timeStr,
                  style: const TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.large(
                  onPressed: _toggleTimer,
                  child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: _resetTimer,
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
