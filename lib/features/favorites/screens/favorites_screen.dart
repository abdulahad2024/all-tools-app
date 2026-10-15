import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/tool_categories.dart';
import '../../../core/localization/localization_provider.dart';
import '../../../core/providers/favorites_provider.dart';
import '../../common/widgets/tool_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langNotifier = ref.watch(languageProvider.notifier);
    final favoriteIds = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(langNotifier.translate('favorite_tools')),
        actions: [
          if (favoriteIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.red),
              tooltip: langNotifier.translate('clear_favorites'),
              onPressed: () {
                ref.read(favoritesProvider.notifier).clearFavorites();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Favorites cleared')),
                );
              },
            ),
        ],
      ),
      body: favoriteIds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_border, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    langNotifier.translate('no_favorites'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      langNotifier.translate('no_favorites_sub'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteIds.length,
              itemBuilder: (context, index) {
                final toolId = favoriteIds.elementAt(index);
                final tool = ToolCategories.getToolById(toolId);
                return ToolCard(tool: tool);
              },
            ),
    );
  }
}
