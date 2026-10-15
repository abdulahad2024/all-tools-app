import 'package:flutter/material.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController(text: '100');
  String _fromCurr = 'USD';
  String _toCurr = 'BDT';
  double _result = 12150.0;

  final Map<String, double> _ratesToUsd = {
    'USD': 1.0,
    'BDT': 121.5,
    'EUR': 0.92,
    'GBP': 0.78,
    'INR': 83.5,
  };

  void _convertCurrency() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    double fromRate = _ratesToUsd[_fromCurr] ?? 1.0;
    double toRate = _ratesToUsd[_toCurr] ?? 1.0;

    double amountInUsd = amount / fromRate;
    double converted = amountInUsd * toRate;

    setState(() => _result = converted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Exchange Converter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
            onChanged: (_) => _convertCurrency(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _fromCurr,
                  decoration: const InputDecoration(labelText: 'From', border: OutlineInputBorder()),
                  items: _ratesToUsd.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    setState(() => _fromCurr = val!);
                    _convertCurrency();
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.swap_horiz, size: 32, color: Colors.blue),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _toCurr,
                  decoration: const InputDecoration(labelText: 'To', border: OutlineInputBorder()),
                  items: _ratesToUsd.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    setState(() => _toCurr = val!);
                    _convertCurrency();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.green.shade100,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Converted Total', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    '${_result.toStringAsFixed(2)} $_toCurr',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
