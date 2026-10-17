import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/localization_provider.dart';
import '../../../core/providers/favorites_provider.dart';
import '../../../core/providers/history_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../common/widgets/responsive_container.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langNotifier = ref.watch(languageProvider.notifier);
    final currentLang = ref.watch(languageProvider);
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(langNotifier.translate('settings_title')),
      ),
      body: ResponsiveContainer(
        maxWidth: 850,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Appearance Section
            _buildSectionHeader(context, langNotifier.translate('appearance'), Icons.palette),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.brightness_medium),
                    title: Text(langNotifier.translate('theme_mode')),
                    trailing: DropdownButton<ThemeMode>(
                      value: currentTheme,
                      items: [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text(langNotifier.translate('theme_system')),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text(langNotifier.translate('theme_light')),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text(langNotifier.translate('theme_dark')),
                        ),
                      ],
                      onChanged: (mode) {
                        if (mode != null) {
                          ref.read(themeProvider.notifier).setThemeMode(mode);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(langNotifier.translate('language')),
                    trailing: SegmentedButton<String>(
                      segments: [
                        ButtonSegment(value: 'en', label: Text(langNotifier.translate('lang_english'))),
                        ButtonSegment(value: 'bn', label: Text(langNotifier.translate('lang_bengali'))),
                      ],
                      selected: {currentLang},
                      onSelectionChanged: (newSelection) {
                        ref.read(languageProvider.notifier).setLanguage(newSelection.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Privacy Section
            _buildSectionHeader(context, langNotifier.translate('privacy_permissions'), Icons.security),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.offline_pin, color: Colors.green),
                title: const Text('Offline-First Architecture'),
                subtitle: Text(langNotifier.translate('privacy_desc')),
              ),
            ),
            const SizedBox(height: 24),

            // Data Management
            _buildSectionHeader(context, langNotifier.translate('storage_management'), Icons.storage),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.cleaning_services, color: Colors.red),
                title: Text(langNotifier.translate('clear_app_data')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(langNotifier.translate('clear_app_data')),
                      content: const Text('Are you sure you want to clear all favorites and search history?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                          child: const Text('Reset'),
                          onPressed: () {
                            ref.read(favoritesProvider.notifier).clearFavorites();
                            ref.read(historyProvider.notifier).clearHistory();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(langNotifier.translate('data_reset_confirm'))),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // About Section
            _buildSectionHeader(context, langNotifier.translate('about_app'), Icons.info),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.grid_view_rounded, size: 36, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    const Text('All Tools', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(langNotifier.translate('app_version'), style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    Text(
                      langNotifier.translate('app_description'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Divider(height: 24),
                    Text(
                      langNotifier.translate('developer_credit'),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
