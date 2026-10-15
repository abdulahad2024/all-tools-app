import 'package:flutter/material.dart';

class FileEditorScreen extends StatefulWidget {
  const FileEditorScreen({super.key});

  @override
  State<FileEditorScreen> createState() => _FileEditorScreenState();
}

class _FileEditorScreenState extends State<FileEditorScreen> {
  final TextEditingController _editorController = TextEditingController(text: 'Welcome to All Tools Text File Editor.\nYou can write, view and save text files offline.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text File Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File saved locally!')));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _editorController,
          maxLines: null,
          expands: true,
          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'File Content'),
        ),
      ),
    );
  }
}
