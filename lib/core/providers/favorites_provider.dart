import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage_provider.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final Ref _ref;

  FavoritesNotifier(this._ref) : super({}) {
    _loadFavorites();
  }

  void _loadFavorites() {
    final storage = _ref.read(storageServiceProvider);
    final favList = storage.getFavorites();
    state = favList.toSet();
  }

  void toggleFavorite(String toolId) {
    final newSet = Set<String>.from(state);
    if (newSet.contains(toolId)) {
      newSet.remove(toolId);
    } else {
      newSet.add(toolId);
    }
    state = newSet;
    final storage = _ref.read(storageServiceProvider);
    storage.setFavorites(newSet.toList());
  }

  bool isFavorite(String toolId) {
    return state.contains(toolId);
  }

  void clearFavorites() {
    state = {};
    final storage = _ref.read(storageServiceProvider);
    storage.setFavorites([]);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier(ref);
});
