import 'package:flutter_riverpod/flutter_riverpod.dart';

final qrTypeProvider = StateProvider<String>((ref) => 'URL');
final qrInputTextProvider = StateProvider<String>((ref) => 'https://flutter.dev');
final scannedQrResultProvider = StateProvider<String>((ref) => 'Scan a QR or Barcode using camera');

class QrHistoryNotifier extends StateNotifier<List<String>> {
  QrHistoryNotifier() : super([
    'https://flutter.dev',
    'Wi-Fi: Home_WiFi_5G (Pass: 12345678)',
    'vCard: John Doe (Phone: +8801700000000)',
  ]);

  void addQrToHistory(String qrData) {
    if (qrData.trim().isEmpty) return;
    final updated = List<String>.from(state);
    updated.removeWhere((item) => item == qrData);
    updated.insert(0, qrData);
    state = updated;
  }

  void clearHistory() {
    state = [];
  }
}

final qrHistoryProvider = StateNotifierProvider<QrHistoryNotifier, List<String>>((ref) {
  return QrHistoryNotifier();
});
