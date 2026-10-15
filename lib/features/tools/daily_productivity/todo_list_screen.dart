import 'package:flutter/material.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Map<String, dynamic>> _todos = [
    {'title': 'Complete Flutter All Tools app UI', 'done': true},
    {'title': 'Review Riverpod state providers', 'done': false},
    {'title': 'Test offline database persistence', 'done': false},
  ];
  final TextEditingController _taskController = TextEditingController();

  void _addTodo() {
    if (_taskController.text.trim().isEmpty) return;
    setState(() {
      _todos.add({'title': _taskController.text.trim(), 'done': false});
      _taskController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do Task Manager')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Add new task...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _addTodo,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo['done'],
                    onChanged: (val) => setState(() => todo['done'] = val),
                  ),
                  title: Text(
                    todo['title'],
                    style: TextStyle(
                      decoration: todo['done'] ? TextDecoration.lineThrough : null,
                      color: todo['done'] ? Colors.grey : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => setState(() => _todos.removeAt(index)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
