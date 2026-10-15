import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLanguage = 'app_language';
  static const String _keyFavorites = 'favorite_tools';
  static const String _keyHistory = 'history_tools';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Theme
  String getThemeMode() => _prefs.getString(_keyThemeMode) ?? 'system';
  Future<void> setThemeMode(String mode) => _prefs.setString(_keyThemeMode, mode);

  // Language
  String getLanguage() => _prefs.getString(_keyLanguage) ?? 'bn'; // Default to Bengali as requested
  Future<void> setLanguage(String lang) => _prefs.setString(_keyLanguage, lang);

  // Favorites
  List<String> getFavorites() => _prefs.getStringList(_keyFavorites) ?? [];
  Future<void> setFavorites(List<String> favorites) => _prefs.setStringList(_keyFavorites, favorites);

  // History (stored as "toolId|timestamp")
  List<String> getHistory() => _prefs.getStringList(_keyHistory) ?? [];
  Future<void> setHistory(List<String> history) => _prefs.setStringList(_keyHistory, history);

  // Clear all app state
  Future<void> clearAllData() async {
    await _prefs.remove(_keyFavorites);
    await _prefs.remove(_keyHistory);
  }
}
