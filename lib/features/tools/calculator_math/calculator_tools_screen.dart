import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

class BasicCalculatorScreen extends StatefulWidget {
  const BasicCalculatorScreen({super.key});

  @override
  State<BasicCalculatorScreen> createState() => _BasicCalculatorScreenState();
}

class _BasicCalculatorScreenState extends State<BasicCalculatorScreen> {
  String _expression = '';
  String _result = '0';

  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        _expression = '';
        _result = '0';
      } else if (text == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (text == '=') {
        _evaluate();
      } else {
        _expression += text;
      }
    });
  }

  void _evaluate() {
    try {
      String expStr = _expression.replaceAll('×', '*').replaceAll('÷', '/');
      ShuntingYardParser p = ShuntingYardParser();
      Expression exp = p.parse(expStr);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _result = eval.toStringAsFixed(eval.truncateToDouble() == eval ? 0 : 4);
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  Widget _buildCalcButton(String text, {Color? bg, Color? fg}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bg ?? Theme.of(context).colorScheme.surfaceContainerHighest,
            foregroundColor: fg ?? Theme.of(context).colorScheme.onSurface,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: () => _onButtonPressed(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 28, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildCalcButton('C', bg: Colors.red.shade100, fg: Colors.red),
                    _buildCalcButton('⌫', bg: Colors.orange.shade100, fg: Colors.orange),
                    _buildCalcButton('%', bg: Colors.blue.shade100, fg: Colors.blue),
                    _buildCalcButton('÷', bg: Colors.blue.shade100, fg: Colors.blue),
                  ],
                ),
                Row(
                  children: [
                    _buildCalcButton('7'),
                    _buildCalcButton('8'),
                    _buildCalcButton('9'),
                    _buildCalcButton('×', bg: Colors.blue.shade100, fg: Colors.blue),
                  ],
                ),
                Row(
                  children: [
                    _buildCalcButton('4'),
                    _buildCalcButton('5'),
                    _buildCalcButton('6'),
                    _buildCalcButton('-', bg: Colors.blue.shade100, fg: Colors.blue),
                  ],
                ),
                Row(
                  children: [
                    _buildCalcButton('1'),
                    _buildCalcButton('2'),
                    _buildCalcButton('3'),
                    _buildCalcButton('+', bg: Colors.blue.shade100, fg: Colors.blue),
                  ],
                ),
                Row(
                  children: [
                    _buildCalcButton('00'),
                    _buildCalcButton('0'),
                    _buildCalcButton('.'),
                    _buildCalcButton('=', bg: Colors.blue, fg: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime? _dob;
  final DateTime _today = DateTime.now();
  Map<String, int>? _ageResult;

  void _calculateAge() {
    if (_dob == null) return;
    int years = _today.year - _dob!.year;
    int months = _today.month - _dob!.month;
    int days = _today.day - _dob!.day;

    if (days < 0) {
      months -= 1;
      final prevMonthDays = DateTime(_today.year, _today.month, 0).day;
      days += prevMonthDays;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    final totalDays = _today.difference(_dob!).inDays;

    setState(() {
      _ageResult = {
        'years': years,
        'months': months,
        'days': days,
        'totalDays': totalDays,
        'totalHours': totalDays * 24,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.cake, color: Colors.blue),
                    title: const Text('Date of Birth'),
                    subtitle: Text(
                      _dob == null ? 'Select your birth date' : DateFormat('dd MMM yyyy').format(_dob!),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _dob ?? DateTime(2000, 1, 1),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _dob = picked);
                        _calculateAge();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_ageResult != null) ...[
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Your Exact Age', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatBox('${_ageResult!['years']}', 'Years'),
                        _buildStatBox('${_ageResult!['months']}', 'Months'),
                        _buildStatBox('${_ageResult!['days']}', 'Days'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.today),
                      title: const Text('Total Days'),
                      trailing: Text('${_ageResult!['totalDays']} Days', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Total Hours'),
                      trailing: Text('${_ageResult!['totalHours']} Hours', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatBox(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class EmiCalculatorScreen extends StatefulWidget {
  const EmiCalculatorScreen({super.key});

  @override
  State<EmiCalculatorScreen> createState() => _EmiCalculatorScreenState();
}

class _EmiCalculatorScreenState extends State<EmiCalculatorScreen> {
  final _amountController = TextEditingController(text: '100000');
  final _rateController = TextEditingController(text: '10');
  final _tenureController = TextEditingController(text: '12');

  double _emi = 0;
  double _totalInterest = 0;
  double _totalPayment = 0;

  void _calculateEmi() {
    double p = double.tryParse(_amountController.text) ?? 0;
    double r = (double.tryParse(_rateController.text) ?? 0) / 12 / 100;
    int n = int.tryParse(_tenureController.text) ?? 0;

    if (p > 0 && r > 0 && n > 0) {
      double emiVal = (p * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
      double totalPay = emiVal * n;
      double interest = totalPay - p;

      setState(() {
        _emi = emiVal;
        _totalPayment = totalPay;
        _totalInterest = interest;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EMI / Loan Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Loan Amount (৳ / \$)', border: OutlineInputBorder()),
            onChanged: (_) => _calculateEmi(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _rateController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Interest Rate per Year (%)', border: OutlineInputBorder()),
            onChanged: (_) => _calculateEmi(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tenureController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Tenure (Months)', border: OutlineInputBorder()),
            onChanged: (_) => _calculateEmi(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            onPressed: _calculateEmi,
            child: const Text('Calculate EMI', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 20),
          if (_emi > 0) ...[
            Card(
              color: Colors.green.shade100,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Monthly EMI', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('৳ ${_emi.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Principal Amount'),
                      trailing: Text('৳ ${_amountController.text}'),
                    ),
                    ListTile(
                      title: const Text('Total Interest'),
                      trailing: Text('৳ ${_totalInterest.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Total Payable Amount'),
                      trailing: Text('৳ ${_totalPayment.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final _heightController = TextEditingController(text: '170'); // cm
  final _weightController = TextEditingController(text: '65'); // kg

  double? _bmi;
  String _category = '';
  Color _color = Colors.green;

  void _calculateBmi() {
    double h = (double.tryParse(_heightController.text) ?? 0) / 100;
    double w = double.tryParse(_weightController.text) ?? 0;

    if (h > 0 && w > 0) {
      double bmiVal = w / (h * h);
      String cat = '';
      Color col = Colors.green;

      if (bmiVal < 18.5) {
        cat = 'Underweight';
        col = Colors.orange;
      } else if (bmiVal < 25) {
        cat = 'Normal weight';
        col = Colors.green;
      } else if (bmiVal < 30) {
        cat = 'Overweight';
        col = Colors.amber;
      } else {
        cat = 'Obesity';
        col = Colors.red;
      }

      setState(() {
        _bmi = bmiVal;
        _category = cat;
        _color = col;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder()),
            onChanged: (_) => _calculateBmi(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()),
            onChanged: (_) => _calculateBmi(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            onPressed: _calculateBmi,
            child: const Text('Calculate BMI', style: TextStyle(fontSize: 18)),
          ),
          if (_bmi != null) ...[
            const SizedBox(height: 24),
            Card(
              color: _color.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('BMI Score', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 8),
                    Text(
                      _bmi!.toStringAsFixed(1),
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: _color),
                    ),
                    Text(
                      _category,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _color),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
