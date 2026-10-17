import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../productivity_provider/productivity_tools_provider.dart';
import '../productivity_utils/productivity_models.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final notifier = ref.read(todoListProvider.notifier);
    final TextEditingController taskController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('To-Do Task Manager')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: prodHero('To-Do & Task Manager', 'Organize daily tasks and track completion progress', Colors.green, Icons.checklist),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      hintText: 'Add new task...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (val) {
                      notifier.addTodo(val);
                      taskController.clear();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    notifier.addTodo(taskController.text);
                    taskController.clear();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo['done'] as bool,
                      onChanged: (_) => notifier.toggleTodo(index),
                    ),
                    title: Text(
                      todo['title'] as String,
                      style: TextStyle(
                        decoration: (todo['done'] as bool) ? TextDecoration.lineThrough : null,
                        color: (todo['done'] as bool) ? Colors.grey : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => notifier.removeTodo(index),
                    ),
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
