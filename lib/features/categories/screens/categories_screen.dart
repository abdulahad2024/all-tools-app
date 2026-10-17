import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/tool_categories.dart';
import '../../../core/localization/localization_provider.dart';
import '../../common/widgets/responsive_container.dart';
import 'category_detail_screen.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final langNotifier = ref.watch(languageProvider.notifier);
    final lang = ref.watch(languageProvider);
    final width = MediaQuery.of(context).size.width;
    final gridCount = width > 900 ? 4 : (width > 600 ? 3 : 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(langNotifier.translate('all_categories')),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: ResponsiveContainer(
        maxWidth: 1000,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isGridView
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount,
                    childAspectRatio: 1.15,
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
                          color: cat.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: cat.color.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: cat.color,
                              radius: 20,
                              child: Icon(cat.icon, color: Colors.white, size: 22),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat.getName(lang),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                )
              : ListView.builder(
                  itemCount: ToolCategories.categories.length,
                  itemBuilder: (context, index) {
                    final cat = ToolCategories.categories[index];
                    final toolCount = ToolCategories.getToolsForCategory(cat.id).length;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: cat.color,
                          child: Icon(cat.icon, color: Colors.white),
                        ),
                        title: Text(cat.getName(lang), style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(cat.getDescription(lang), maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Chip(
                          label: Text('$toolCount Tools', style: const TextStyle(fontSize: 12)),
                          backgroundColor: cat.color.withOpacity(0.15),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailScreen(category: cat),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
