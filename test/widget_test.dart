import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:all_tools_app/main.dart';
import 'package:all_tools_app/core/providers/storage_provider.dart';

void main() {
  testWidgets('App loads splash screen successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const AllToolsApp(),
      ),
    );

    expect(find.text('All Tools'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}
