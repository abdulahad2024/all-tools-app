import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../finance_provider/finance_tools_provider.dart';
import '../finance_utils/finance_models.dart';

class BudgetCalculatorScreen extends ConsumerWidget {
  const BudgetCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomeStr = ref.watch(monthlyIncomeProvider);
    final expenses = ref.watch(expensesListProvider);
    final notifier = ref.read(expensesListProvider.notifier);

    double totalIncome = double.tryParse(incomeStr) ?? 0;
    double totalExpense = expenses.fold(0, (sum, item) => sum + (item['amount'] as double));
    double netSavings = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Budget & Expense')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          finHero('Monthly Budget & Expense', 'Plan income, track expenses and monitor monthly savings', Colors.lightGreen.shade800, Icons.account_balance_wallet),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: incomeStr,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Monthly Income (৳ / \$)', border: OutlineInputBorder()),
            onChanged: (val) => ref.read(monthlyIncomeProvider.notifier).state = val,
          ),
          const SizedBox(height: 16),
          Card(
            color: netSavings >= 0 ? Colors.green.shade100 : Colors.red.shade100,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Net Savings:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    '৳ ${netSavings.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: netSavings >= 0 ? Colors.green.shade800 : Colors.red.shade800,
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
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.blue),
                onPressed: () {
                  notifier.addExpense('Shopping', 2500.0);
                },
              ),
            ],
          ),
          ...expenses.asMap().entries.map((entry) {
            final index = entry.key;
            final exp = entry.value;
            return Card(
              child: ListTile(
                title: Text(exp['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('৳ ${exp['amount']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => notifier.removeExpense(index),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
