import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../file_provider/file_tools_provider.dart';

class FileEditorScreen extends ConsumerWidget {
  const FileEditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textContent = ref.watch(textFileContentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Text File Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File saved locally!'), backgroundColor: Colors.green));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          initialValue: textContent,
          maxLines: null,
          expands: true,
          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'File Content'),
          onChanged: (val) => ref.read(textFileContentProvider.notifier).state = val,
        ),
      ),
    );
  }
}
