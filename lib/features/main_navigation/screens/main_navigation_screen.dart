import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/localization_provider.dart';
import '../../categories/screens/categories_screen.dart';
import '../../favorites/screens/favorites_screen.dart';
import '../../history/screens/history_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../settings/screens/settings_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final langNotifier = ref.watch(languageProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 700;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  radius: 24,
                  child: const Icon(Icons.grid_view_rounded, color: Colors.blue),
                ),
              ),
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: Text(langNotifier.translate('nav_home')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.category_outlined),
                  selectedIcon: const Icon(Icons.category),
                  label: Text(langNotifier.translate('nav_categories')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.star_outline),
                  selectedIcon: const Icon(Icons.star),
                  label: Text(langNotifier.translate('nav_favorites')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.history),
                  selectedIcon: const Icon(Icons.history_toggle_off),
                  label: Text(langNotifier.translate('nav_history')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
                  label: Text(langNotifier.translate('nav_settings')),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: langNotifier.translate('nav_home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.category_outlined),
            selectedIcon: const Icon(Icons.category),
            label: langNotifier.translate('nav_categories'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.star_outline),
            selectedIcon: const Icon(Icons.star),
            label: langNotifier.translate('nav_favorites'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.history),
            selectedIcon: const Icon(Icons.history_toggle_off),
            label: langNotifier.translate('nav_history'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: langNotifier.translate('nav_settings'),
          ),
        ],
      ),
    );
  }
}
