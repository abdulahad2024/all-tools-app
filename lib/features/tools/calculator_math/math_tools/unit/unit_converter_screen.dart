// ───────────────────────── unit converter ─────────────────────────
import 'package:all_tools_app/features/tools/calculator_math/math_tools/math_utils/math_utils.dart';
import 'package:flutter/material.dart';

const units = <String, Map<String, double>>{
  'Length': {
    'Millimeter': 0.001, 'Centimeter': 0.01, 'Meter': 1, 'Kilometer': 1000,
    'Inch': 0.0254, 'Foot': 0.3048, 'Yard': 0.9144, 'Mile': 1609.344,
  },
  'Weight': {
    'Milligram': 0.000001, 'Gram': 0.001, 'Kilogram': 1, 'Ton (metric)': 1000,
    'Ounce': 0.0283495, 'Pound': 0.45359237, 'Seer (BD)': 0.933105,
  },
  'Area': {
    'Sq Inch': 0.00064516, 'Sq Foot': 0.09290304, 'Sq Meter': 1, 'Sq Kilometer': 1000000,
    'Acre': 4046.8564, 'Hectare': 10000, 'Katha (BD)': 66.8903, 'Bigha (BD)': 1337.806,
  },
  'Volume': {
    'Milliliter': 0.001, 'Liter': 1, 'Cubic Meter': 1000, 'Gallon (US)': 3.785411784,
    'Cup (US)': 0.2365882, 'Fluid Oz (US)': 0.0295735,
  },
  'Temperature': {'Celsius': 1, 'Fahrenheit': 1, 'Kelvin': 1},
};

double conv(String cat, String f, String t, double x) {
  if (cat == 'Temperature') {
    final c = f == 'Celsius' ? x : (f == 'Fahrenheit' ? (x - 32) * 5 / 9 : x - 273.15);
    return t == 'Celsius' ? c : (t == 'Fahrenheit' ? c * 9 / 5 + 32 : c + 273.15);
  }
  return x * units[cat]![f]! / units[cat]![t]!;
}

class UnitConverterScreen extends StatefulWidget {
  final Tool t;
  const UnitConverterScreen(this.t, {super.key});
  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreen();
}

class _UnitConverterScreen extends State<UnitConverterScreen> {
  String cat = 'Length', from = 'Meter', to = 'Centimeter', val = '1';

  @override
  Widget build(BuildContext context) {
    final nm = units[cat]!.keys.toList();
    final x = n(val);
    return Pg(widget.t, [
      dd('Category', cat, units.keys.toList(), (s) {
        setState(() {
          cat = s;
          final l = units[s]!.keys.toList();
          from = l[0];
          to = l[1];
        });
      }),
      tf('Value', val, (s) => setState(() => val = s)),
      Row(children: [
        Expanded(child: dd('From', from, nm, (s) => setState(() => from = s))),
        IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => setState(() {
              final tmp = from;
              from = to;
              to = tmp;
            })),
        Expanded(child: dd('To', to, nm, (s) => setState(() => to = s))),
      ]),
      hero(widget.t, '${fmt(x, 6)} $from =', '${fmt(conv(cat, from, to, x), 6)}  $to'),
      rows([for (final k in nm) R(k, fmt(conv(cat, from, k, x), 6))]),
    ]);
  }
}