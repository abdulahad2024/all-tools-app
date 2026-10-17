import 'package:flutter_riverpod/flutter_riverpod.dart';

final rawJsonInputProvider = StateProvider<String>((ref) => '{"name":"All Tools","version":1.0,"features":["Math","PDF","Dev"]}');
final formattedJsonOutputProvider = StateProvider<String>((ref) => '');
final jsonStatusProvider = StateProvider<String>((ref) => '');

final modelTargetLanguageProvider = StateProvider<String>((ref) => 'Dart');
final generatedModelCodeProvider = StateProvider<String>((ref) => '');

final hashInputStringProvider = StateProvider<String>((ref) => 'All Tools App');
final generatedUuidProvider = StateProvider<String>((ref) => '');

final jwtTokenInputProvider = StateProvider<String>((ref) => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c');
final timestampEpochInputProvider = StateProvider<String>((ref) => '1700000000');
