import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/tool_categories.dart';
import '../../../core/localization/localization_provider.dart';
import '../../../core/providers/history_provider.dart';
import '../../common/widgets/tool_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langNotifier = ref.watch(languageProvider.notifier);
    final historyIds = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(langNotifier.translate('recently_used')),
        actions: [
          if (historyIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: langNotifier.translate('clear_history'),
              onPressed: () {
                ref.read(historyProvider.notifier).clearHistory();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(langNotifier.translate('history_cleared'))),
                );
              },
            ),
        ],
      ),
      body: historyIds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    langNotifier.translate('no_history'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      langNotifier.translate('no_history_sub'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyIds.length,
              itemBuilder: (context, index) {
                final toolId = historyIds[index];
                final tool = ToolCategories.getToolById(toolId);
                return ToolCard(tool: tool);
              },
            ),
    );
  }
}
