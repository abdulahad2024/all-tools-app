import 'package:flutter/material.dart';

class BudgetCalculatorScreen extends StatefulWidget {
  const BudgetCalculatorScreen({super.key});

  @override
  State<BudgetCalculatorScreen> createState() => _BudgetCalculatorScreenState();
}

class _BudgetCalculatorScreenState extends State<BudgetCalculatorScreen> {
  final TextEditingController _incomeController = TextEditingController(text: '50000');
  final List<Map<String, dynamic>> _expenses = [
    {'name': 'House Rent', 'amount': 15000.0},
    {'name': 'Food & Groceries', 'amount': 12000.0},
    {'name': 'Utilities & Bills', 'amount': 4000.0},
  ];

  double get _totalIncome => double.tryParse(_incomeController.text) ?? 0;
  double get _totalExpense => _expenses.fold(0, (sum, item) => sum + (item['amount'] as double));
  double get _netSavings => _totalIncome - _totalExpense;

  void _addExpense() {
    setState(() {
      _expenses.add({'name': 'Shopping', 'amount': 2500.0});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Budget & Expense')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _incomeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Monthly Income (৳ / \$)', border: OutlineInputBorder()),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Card(
            color: _netSavings >= 0 ? Colors.green.shade100 : Colors.red.shade100,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Net Savings:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    '৳ ${_netSavings.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _netSavings >= 0 ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Expenses List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle, color: Colors.blue), onPressed: _addExpense),
            ],
          ),
          ..._expenses.asMap().entries.map((entry) {
            final index = entry.key;
            final exp = entry.value;
            return Card(
              child: ListTile(
                title: Text(exp['name']),
                subtitle: Text('৳ ${exp['amount']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => setState(() => _expenses.removeAt(index)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
