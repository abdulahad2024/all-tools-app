import 'dart:async';
import 'package:flutter/material.dart';

class TotpAuthenticatorScreen extends StatefulWidget {
  const TotpAuthenticatorScreen({super.key});

  @override
  State<TotpAuthenticatorScreen> createState() => _TotpAuthenticatorScreenState();
}

class _TotpAuthenticatorScreenState extends State<TotpAuthenticatorScreen> {
  int _secondsLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsLeft > 1) {
          _secondsLeft--;
        } else {
          _secondsLeft = 30;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2FA TOTP Authenticator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOtpCard('Google Account', '749 201'),
          _buildOtpCard('GitHub Developer', '109 843'),
          _buildOtpCard('Binance Crypto', '582 910'),
        ],
      ),
    );
  }

  Widget _buildOtpCard(String account, String code) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.security)),
        title: Text(account, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(code, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue, letterSpacing: 2)),
        trailing: SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(value: _secondsLeft / 30),
              Text('$_secondsLeft', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
