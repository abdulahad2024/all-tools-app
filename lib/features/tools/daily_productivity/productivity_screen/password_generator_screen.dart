import 'dart:math';
import 'package:flutter/material.dart';
import '../productivity_utils/productivity_models.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  double _length = 14;
  bool _includeUpper = true;
  bool _includeLower = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  String _generatedPassword = '';

  void _generatePassword() {
    String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String lower = 'abcdefghijklmnopqrstuvwxyz';
    String numbers = '0123456789';
    String symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String allowedChars = '';
    if (_includeUpper) allowedChars += upper;
    if (_includeLower) allowedChars += lower;
    if (_includeNumbers) allowedChars += numbers;
    if (_includeSymbols) allowedChars += symbols;

    if (allowedChars.isEmpty) {
      setState(() => _generatedPassword = 'Select at least one option!');
      return;
    }

    final rand = Random.secure();
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < _length.toInt(); i++) {
      buffer.write(allowedChars[rand.nextInt(allowedChars.length)]);
    }

    setState(() => _generatedPassword = buffer.toString());
  }

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password Generator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          prodHero('Password Generator', 'Generate unbreakable secure passwords and test strength', Colors.blue, Icons.password),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SelectableText(
                    _generatedPassword,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Generate New Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: _generatePassword,
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Length: ${_length.toInt()} characters'),
                  subtitle: Slider(
                    value: _length,
                    min: 6,
                    max: 32,
                    divisions: 26,
                    onChanged: (val) {
                      setState(() => _length = val);
                      _generatePassword();
                    },
                  ),
                ),
                SwitchListTile(
                  title: const Text('Uppercase Letters (A-Z)'),
                  value: _includeUpper,
                  onChanged: (val) {
                    setState(() => _includeUpper = val);
                    _generatePassword();
                  },
                ),
                SwitchListTile(
                  title: const Text('Lowercase Letters (a-z)'),
                  value: _includeLower,
                  onChanged: (val) {
                    setState(() => _includeLower = val);
                    _generatePassword();
                  },
                ),
                SwitchListTile(
                  title: const Text('Numbers (0-9)'),
                  value: _includeNumbers,
                  onChanged: (val) {
                    setState(() => _includeNumbers = val);
                    _generatePassword();
                  },
                ),
                SwitchListTile(
                  title: const Text('Symbols (!@#\$)'),
                  value: _includeSymbols,
                  onChanged: (val) {
                    setState(() => _includeSymbols = val);
                    _generatePassword();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
