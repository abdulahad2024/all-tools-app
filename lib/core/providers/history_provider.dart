import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage_provider.dart';

class HistoryNotifier extends StateNotifier<List<String>> {
  final Ref _ref;

  HistoryNotifier(this._ref) : super([]) {
    _loadHistory();
  }

  void _loadHistory() {
    final storage = _ref.read(storageServiceProvider);
    state = storage.getHistory();
  }

  void addToolToHistory(String toolId) {
    final newList = List<String>.from(state);
    newList.removeWhere((id) => id == toolId);
    newList.insert(0, toolId); // Add to top
    if (newList.length > 30) {
      newList.removeLast();
    }
    state = newList;
    final storage = _ref.read(storageServiceProvider);
    storage.setHistory(newList);
  }

  void clearHistory() {
    state = [];
    final storage = _ref.read(storageServiceProvider);
    storage.setHistory([]);
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, List<String>>((ref) {
  return HistoryNotifier(ref);
});
