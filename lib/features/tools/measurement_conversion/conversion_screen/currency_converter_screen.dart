import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../conversion_provider/conversion_tools_provider.dart';
import '../conversion_utils/conversion_models.dart';

class CurrencyConverterScreen extends ConsumerStatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  ConsumerState<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends ConsumerState<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController(text: '100');
  double _result = 12150.0;

  final Map<String, double> _ratesToUsd = {
    'USD': 1.0,
    'BDT': 121.5,
    'EUR': 0.92,
    'GBP': 0.78,
    'INR': 83.5,
  };

  void _convertCurrency() {
    final fromCurr = ref.read(currencyFromProvider);
    final toCurr = ref.read(currencyToProvider);

    double amount = double.tryParse(_amountController.text) ?? 0;
    double fromRate = _ratesToUsd[fromCurr] ?? 1.0;
    double toRate = _ratesToUsd[toCurr] ?? 1.0;

    double amountInUsd = amount / fromRate;
    double converted = amountInUsd * toRate;

    setState(() => _result = converted);
  }

  @override
  Widget build(BuildContext context) {
    final fromCurr = ref.watch(currencyFromProvider);
    final toCurr = ref.watch(currencyToProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Currency Exchange Converter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          convHero('Currency Converter', 'Convert USD, BDT, EUR, GBP, INR & major currencies offline', Colors.green, Icons.currency_exchange),
          const SizedBox(height: 16),
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
                  initialValue: fromCurr,
                  decoration: const InputDecoration(labelText: 'From', border: OutlineInputBorder()),
                  items: _ratesToUsd.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(currencyFromProvider.notifier).state = val;
                      _convertCurrency();
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.swap_horiz, size: 32, color: Colors.blue),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: toCurr,
                  decoration: const InputDecoration(labelText: 'To', border: OutlineInputBorder()),
                  items: _ratesToUsd.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(currencyToProvider.notifier).state = val;
                      _convertCurrency();
                    }
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
                    '${_result.toStringAsFixed(2)} $toCurr',
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
