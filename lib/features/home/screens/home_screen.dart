import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/tool_categories.dart';
import '../../../core/localization/localization_provider.dart';
import '../../../core/models/tool_model.dart';
import '../../../core/providers/favorites_provider.dart';
import '../../../core/providers/history_provider.dart';
import '../../categories/screens/category_detail_screen.dart';
import '../../common/widgets/tool_card.dart';
import '../../tools/tool_screen_dispatcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<ToolModel> _getFilteredTools(String query, String lang) {
    if (query.trim().isEmpty) return [];
    final q = query.trim().toLowerCase();
    return ToolCategories.tools.where((tool) {
      final name = tool.getTitle(lang).toLowerCase();
      final desc = tool.getDescription(lang).toLowerCase();
      final tags = tool.tags.join(' ').toLowerCase();
      return name.contains(q) || desc.contains(q) || tags.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final langNotifier = ref.watch(languageProvider.notifier);
    final lang = ref.watch(languageProvider);
    final popularTools = ToolCategories.tools.where((t) => t.isPopular).toList();
    final favIds = ref.watch(favoritesProvider);
    final historyIds = ref.watch(historyProvider);

    final searchResults = _getFilteredTools(_searchQuery, lang);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.build_circle, color: Colors.blue),
            ),
            const SizedBox(width: 10),
            Text(langNotifier.translate('app_title')),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Input
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: langNotifier.translate('search_tools_hint'),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
          const SizedBox(height: 16),

          // Search Results View (If query is active)
          if (_searchQuery.trim().isNotEmpty) ...[
            Text(
              '${searchResults.length} Tools Found',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            if (searchResults.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    langNotifier.translate('search_no_results'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              )
            else
              ...searchResults.map((tool) => ToolCard(tool: tool)),
          ] else ...[
            // Quick Access / Popular Tools
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  langNotifier.translate('quick_access'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.bolt, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularTools.length,
                itemBuilder: (context, index) {
                  final tool = popularTools[index];
                  final cat = ToolCategories.getCategoryById(tool.categoryId);
                  return GestureDetector(
                    onTap: () => ToolScreenDispatcher.openTool(context, ref, tool.id),
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: cat.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cat.color.withOpacity(0.3)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(tool.icon, color: cat.color, size: 30),
                          const SizedBox(height: 8),
                          Text(
                            tool.getTitle(lang),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Recently Used Tools (if history exists)
            if (historyIds.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    langNotifier.translate('recently_used'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.history, color: Colors.blue),
                ],
              ),
              const SizedBox(height: 10),
              ...historyIds.take(3).map((id) {
                final tool = ToolCategories.getToolById(id);
                return ToolCard(tool: tool);
              }),
              const SizedBox(height: 16),
            ],

            // Favorites Preview (if favorites exist)
            if (favIds.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    langNotifier.translate('favorite_tools'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.star, color: Colors.amber),
                ],
              ),
              const SizedBox(height: 10),
              ...favIds.take(3).map((id) {
                final tool = ToolCategories.getToolById(id);
                return ToolCard(tool: tool);
              }),
              const SizedBox(height: 16),
            ],

            // Category Overview Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  langNotifier.translate('all_categories'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${ToolCategories.categories.length} Categories',
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Categories Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.25,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: ToolCategories.categories.length,
              itemBuilder: (context, index) {
                final cat = ToolCategories.categories[index];
                final toolCount = ToolCategories.getToolsForCategory(cat.id).length;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailScreen(category: cat),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cat.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cat.color.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: cat.color.withOpacity(0.2),
                          radius: 20,
                          child: Icon(cat.icon, color: cat.color, size: 22),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.getName(lang),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$toolCount Tools',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
