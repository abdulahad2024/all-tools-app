import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoListNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  TodoListNotifier() : super([
    {'title': 'Complete Flutter All Tools app UI', 'done': true},
    {'title': 'Review Riverpod state providers', 'done': false},
    {'title': 'Test offline database persistence', 'done': false},
  ]);

  void addTodo(String title) {
    if (title.trim().isEmpty) return;
    state = [...state, {'title': title.trim(), 'done': false}];
  }

  void toggleTodo(int index) {
    final updated = List<Map<String, dynamic>>.from(state);
    updated[index]['done'] = !(updated[index]['done'] as bool);
    state = updated;
  }

  void removeTodo(int index) {
    final updated = List<Map<String, dynamic>>.from(state)..removeAt(index);
    state = updated;
  }
}

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Map<String, dynamic>>>((ref) {
  return TodoListNotifier();
});
