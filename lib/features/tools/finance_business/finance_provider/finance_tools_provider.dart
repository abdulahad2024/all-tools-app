import 'package:flutter_riverpod/flutter_riverpod.dart';

final monthlyIncomeProvider = StateProvider<String>((ref) => '50000');

class ExpensesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ExpensesNotifier() : super([
    {'name': 'House Rent', 'amount': 15000.0},
    {'name': 'Food & Groceries', 'amount': 12000.0},
    {'name': 'Utilities & Bills', 'amount': 4000.0},
  ]);

  void addExpense(String name, double amount) {
    state = [...state, {'name': name, 'amount': amount}];
  }

  void removeExpense(int index) {
    final updated = List<Map<String, dynamic>>.from(state)..removeAt(index);
    state = updated;
  }
}

final expensesListProvider = StateNotifierProvider<ExpensesNotifier, List<Map<String, dynamic>>>((ref) {
  return ExpensesNotifier();
});
