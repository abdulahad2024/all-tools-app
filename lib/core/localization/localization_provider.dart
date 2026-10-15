import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/storage_provider.dart';
import 'app_translations.dart';

class LanguageNotifier extends StateNotifier<String> {
  final Ref _ref;

  LanguageNotifier(this._ref) : super('bn') {
    _loadLanguage();
  }

  void _loadLanguage() {
    final storage = _ref.read(storageServiceProvider);
    state = storage.getLanguage();
  }

  void setLanguage(String lang) {
    state = lang;
    final storage = _ref.read(storageServiceProvider);
    storage.setLanguage(lang);
  }

  String translate(String key) {
    return AppTranslations.getText(key, state);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier(ref);
});
