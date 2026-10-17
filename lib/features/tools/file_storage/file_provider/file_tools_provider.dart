import 'package:flutter_riverpod/flutter_riverpod.dart';

final textFileContentProvider = StateProvider<String>((ref) => 'Welcome to All Tools Text File Editor.\nYou can write, view and save text files offline.');
