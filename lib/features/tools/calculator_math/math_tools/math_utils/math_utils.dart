// ───────────────────────── helpers ─────────────────────────
import 'dart:math';

import 'package:all_tools_app/features/tools/calculator_math/math_tools/age_and_date/age_and_date_screen.dart';
import 'package:all_tools_app/features/tools/calculator_math/math_tools/cgpa_gpa/cgpa_gpa_screen.dart';
import 'package:all_tools_app/features/tools/calculator_math/math_tools/scientific_calculator/scientific_calculator_screen.dart';
import 'package:all_tools_app/features/tools/calculator_math/math_tools/unit/unit_converter_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String fmt(double v, [int d = 4]) {
  if (v.isNaN || v.isInfinite) return 'Error';
  var s = v.toStringAsFixed(d);
  if (s.contains('.')) s = s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  return s == '-0' ? '0' : s;
}

String money(double v) => NumberFormat('#,##0.00').format(v);
double n(String s) => double.tryParse(s.trim()) ?? 0;
int daysBetween(DateTime x, DateTime y) =>
    DateTime.utc(y.year, y.month, y.day).difference(DateTime.utc(x.year, x.month, x.day)).inDays;

LinearGradient grad(Color c) => LinearGradient(
    colors: [c, Color.lerp(c, Colors.black, .3)!], begin: Alignment.topLeft, end: Alignment.bottomRight);

class Tool {
  final String title, bn;
  final IconData icon;
  final Color color;
  final Widget Function(Tool) page;
  Tool(this.title, this.bn, this.icon, this.color, this.page);
}

class F {
  final String label, def;
  final List<String>? opts;
  final bool text;
  const F(this.label, this.def, {this.opts, this.text = false});
}

class R {
  final String l, v;
  const R(this.l, this.v);
}

InputDecoration deco(String l) => InputDecoration(
    labelText: l,
    filled: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none));

Widget tf(String label, String init, ValueChanged<String> cb, {bool num = true}) => TextFormField(
  initialValue: init,
  keyboardType: num ? const TextInputType.numberWithOptions(decimal: true, signed: true) : TextInputType.text,
  decoration: deco(label),
  onChanged: cb,
);

Widget dd(String l, String v, List<String> items, ValueChanged<String> cb) => DropdownButtonFormField<String>(
  isExpanded: true,
  initialValue: v,
  decoration: deco(l),
  items: [for (final i in items) DropdownMenuItem(value: i, child: Text(i))],
  onChanged: (x) => cb(x!),
);

Widget hero(Tool t, String l, String v) {
  final sz = v.length > 16 ? 16.0 : (v.length > 10 ? 26.0 : 38.0);
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(gradient: grad(t.color), borderRadius: BorderRadius.circular(24)),
    child: Column(children: [
      Text(l, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 15)),
      const SizedBox(height: 6),
      SelectableText(v,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: sz, fontWeight: FontWeight.bold)),
    ]),
  );
}

Widget rows(List<R> r) => Card(
  margin: EdgeInsets.zero,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Column(children: [
      for (var i = 0; i < r.length; i++) ...[
        if (i > 0) const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(children: [
            Expanded(child: Text(r[i].l)),
            const SizedBox(width: 12),
            Flexible(
                child: SelectableText(r[i].v,
                    textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
          ]),
        ),
      ],
    ]),
  ),
);

PreferredSizeWidget bar(Tool t, {List<Widget>? actions}) => AppBar(
  title: Text(t.title),
  foregroundColor: Colors.white,
  actions: actions,
  flexibleSpace: Container(decoration: BoxDecoration(gradient: grad(t.color))),
);

class Pg extends StatelessWidget {
  final Tool t;
  final List<Widget> kids;
  const Pg(this.t, this.kids, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: bar(t),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final k in kids) Padding(key: k.key, padding: const EdgeInsets.only(bottom: 12), child: k),
      ],
    ),
  );
}

// Generic "inputs -> live results" page
class FormCalc extends StatefulWidget {
  final Tool t;
  final List<F> fields;
  final List<R> Function(List<String>) calc;
  final String? action;
  const FormCalc(this.t, this.fields, this.calc, {super.key, this.action});
  @override
  State<FormCalc> createState() => _FormCalcState();
}

class _FormCalcState extends State<FormCalc> {
  late final List<String> v = widget.fields.map((f) => f.def).toList();
  @override
  Widget build(BuildContext context) {
    List<R> r;
    try {
      r = widget.calc(v);
    } catch (_) {
      r = [const R('Result', 'Invalid input')];
    }
    final f = widget.fields;
    return Pg(widget.t, [
      for (var i = 0; i < f.length; i++)
        f[i].opts != null
            ? dd(f[i].label, v[i], f[i].opts!, (x) => setState(() => v[i] = x))
            : tf(f[i].label, f[i].def, (x) => setState(() => v[i] = x), num: !f[i].text),
      if (widget.action != null)
        FilledButton.icon(
            onPressed: () => setState(() {}), icon: const Icon(Icons.casino), label: Text(widget.action!)),
      hero(widget.t, r.first.l, r.first.v),
      if (r.length > 1) rows(r.sublist(1)),
    ]);
  }
}

// ───────────────────────── tools list ─────────────────────────
bool isPrime(int x) {
  if (x < 2) return false;
  if (x < 4) return true;
  if (x % 2 == 0 || x % 3 == 0) return false;
  for (var i = 5; i * i <= x; i += 6) {
    if (x % i == 0 || x % (i + 2) == 0) return false;
  }
  return true;
}

const radix = {'Binary': 2, 'Octal': 8, 'Decimal': 10, 'Hexadecimal': 16};

final tools = <Tool>[
  Tool('Scientific Calculator', 'সাইন্টিফিক ক্যালকুলেটর', Icons.calculate, Colors.indigo, (t) => ScientificCalculatorScreen(t)),
  Tool('Age Calculator', 'বয়স ক্যালকুলেটর', Icons.cake, Colors.pink, (t) => AgeAndDateScreen(t, true)),
  Tool('Date Difference', 'তারিখের পার্থক্য', Icons.date_range, Colors.teal, (t) => AgeAndDateScreen(t, false)),
  Tool('Percentage & Discount', 'শতকরা ও ছাড়', Icons.percent, Colors.orange, (t) => FormCalc(t, const [
    F('Amount / Price (Y)', '1000'),
    F('Percent (X %)', '20'),
  ], (v) {
    final y = n(v[0]), x = n(v[1]), p = y * x / 100;
    return [
      R('${fmt(x)}% of ${fmt(y)}', fmt(p)),
      R('Price after discount', money(y - p)),
      R('You save', money(p)),
      R('Price after adding ${fmt(x)}%', money(y + p)),
    ];
  })),
  Tool('Profit & Loss', 'লাভ-ক্ষতি', Icons.trending_up, Colors.green, (t) => FormCalc(t, const [
    F('Cost Price', '800'),
    F('Selling Price', '1000'),
  ], (v) {
    final c = n(v[0]), s = n(v[1]), d = s - c;
    return [
      R(d >= 0 ? 'Profit' : 'Loss', money(d.abs())),
      R('${d >= 0 ? 'Profit' : 'Loss'} % (on cost)', '${fmt(c == 0 ? 0.0 : d.abs() / c * 100, 2)} %'),
      R('Margin % (on selling price)', '${fmt(s == 0 ? 0.0 : d.abs() / s * 100, 2)} %'),
    ];
  })),
  Tool('EMI / Loan', 'ইএমআই ও লোন', Icons.account_balance, Colors.blue, (t) => FormCalc(t, const [
    F('Loan Amount', '100000'),
    F('Interest Rate per Year (%)', '10'),
    F('Tenure (Months)', '12'),
  ], (v) {
    final p = n(v[0]), r = n(v[1]) / 1200;
    final m = int.tryParse(v[2].trim()) ?? 0;
    if (p <= 0 || m <= 0) throw 0;
    final emi = r == 0 ? p / m : p * r * pow(1 + r, m) / (pow(1 + r, m) - 1);
    final tot = emi * m;
    return [
      R('Monthly EMI', money(emi)),
      R('Principal amount', money(p)),
      R('Total interest', money(tot - p)),
      R('Total payable', money(tot)),
    ];
  })),
  Tool('BMI & BMR', 'বিএমআই ও বিএমআর', Icons.favorite, Colors.red, (t) => FormCalc(t, const [
    F('Height (cm)', '170'),
    F('Weight (kg)', '65'),
    F('Age (years)', '25'),
    F('Gender', 'Male', opts: ['Male', 'Female']),
  ], (v) {
    final h = n(v[0]) / 100, w = n(v[1]), a = n(v[2]);
    if (h <= 0 || w <= 0) throw 0;
    final b = w / (h * h);
    final c = b < 18.5 ? 'Underweight' : b < 25 ? 'Normal weight' : b < 30 ? 'Overweight' : 'Obese';
    final bmr = 10 * w + 6.25 * h * 100 - 5 * a + (v[3] == 'Male' ? 5 : -161);
    return [
      R('BMI • $c', fmt(b, 1)),
      R('BMR (calories/day)', '${fmt(bmr, 0)} kcal'),
      R('Light activity (×1.375)', '${fmt(bmr * 1.375, 0)} kcal'),
      R('Moderate activity (×1.55)', '${fmt(bmr * 1.55, 0)} kcal'),
      R('Healthy weight range', '${fmt(18.5 * h * h, 1)} – ${fmt(24.9 * h * h, 1)} kg'),
    ];
  })),
  Tool('GPA / CGPA', 'জিপিএ ও সিজিপিএ', Icons.school, Colors.purple, (t) => CgpaGpaScreen(t)),
  Tool('Fraction', 'ভগ্নাংশ ক্যালকুলেটর', Icons.pie_chart, Colors.cyan.shade700, (t) => FormCalc(t, const [
    F('Numerator 1', '3'),
    F('Denominator 1', '4'),
    F('Operation', '+', opts: ['+', '−', '×', '÷']),
    F('Numerator 2', '1'),
    F('Denominator 2', '2'),
  ], (v) {
    final a = int.parse(v[0].trim()), b = int.parse(v[1].trim());
    final c = int.parse(v[3].trim()), d = int.parse(v[4].trim());
    if (b == 0 || d == 0) throw 0;
    int nu, de;
    switch (v[2]) {
      case '+':
        nu = a * d + c * b;
        de = b * d;
        break;
      case '−':
        nu = a * d - c * b;
        de = b * d;
        break;
      case '×':
        nu = a * c;
        de = b * d;
        break;
      default:
        if (c == 0) throw 0;
        nu = a * d;
        de = b * c;
    }
    final g = nu.gcd(de);
    if (g > 1) {
      nu ~/= g;
      de ~/= g;
    }
    if (de < 0) {
      nu = -nu;
      de = -de;
    }
    final s = de == 1 ? '$nu' : '$nu/$de';
    return [
      R('${v[0]}/${v[1]} ${v[2]} ${v[3]}/${v[4]} =', s),
      R('Decimal', fmt(nu / de, 6)),
      R('Mixed number', nu.abs() >= de && de > 1 ? '${nu ~/ de} ${nu.abs() % de}/$de' : s),
      R('Percentage', '${fmt(nu / de * 100, 2)} %'),
    ];
  })),
  Tool('Ratio', 'অনুপাত ক্যালকুলেটর', Icons.compare_arrows, Colors.deepOrange, (t) => FormCalc(t, const [
    F('A', '2'),
    F('B', '3'),
    F('C', '10'),
  ], (v) {
    final a = n(v[0]), b = n(v[1]), c = n(v[2]);
    if (a == 0) throw 0;
    final d = b * c / a;
    var simp = '-';
    if (a == a.roundToDouble() && b == b.roundToDouble() && b != 0) {
      final x = a.toInt(), y = b.toInt(), g = x.gcd(y);
      if (g > 0) simp = '${x ~/ g} : ${y ~/ g}';
    }
    return [
      R('A : B = C : D   →   D', fmt(d)),
      R('Simplified A : B', simp),
      R('A ÷ B', b == 0 ? '∞' : fmt(a / b)),
      R('Check A×D = B×C', '${fmt(a * d)} = ${fmt(b * c)}'),
    ];
  })),
  Tool('Average', 'গড় ক্যালকুলেটর', Icons.bar_chart, Colors.amber.shade800, (t) => FormCalc(t, const [
    F('Numbers (comma separated)', '5, 8, 12, 8, 20', text: true),
  ], (v) {
    final x = v[0].split(RegExp(r'[,\s]+')).where((e) => e.isNotEmpty).map(double.parse).toList();
    if (x.isEmpty) throw 0;
    x.sort();
    final s = x.fold<double>(0, (p, e) => p + e), m = s / x.length;
    final med = x.length.isOdd ? x[x.length ~/ 2] : (x[x.length ~/ 2 - 1] + x[x.length ~/ 2]) / 2;
    final cnt = <double, int>{};
    for (final e in x) {
      cnt[e] = (cnt[e] ?? 0) + 1;
    }
    final mx = cnt.values.reduce((a, b) => a > b ? a : b);
    final mode = mx == 1 ? 'No mode' : cnt.entries.where((e) => e.value == mx).map((e) => fmt(e.key)).join(', ');
    return [
      R('Mean (average)', fmt(m)),
      R('Median', fmt(med)),
      R('Mode', mode),
      R('Sum', fmt(s)),
      R('Count', '${x.length}'),
      R('Min / Max', '${fmt(x.first)} / ${fmt(x.last)}'),
      R('Range', fmt(x.last - x.first)),
    ];
  })),
  Tool('Unit Converter', 'পরিমাপ রূপান্তর', Icons.straighten, Colors.teal.shade600, (t) => UnitConverterScreen(t)),
  Tool('Number System', 'সংখ্যা পদ্ধতি রূপান্তর', Icons.memory, Colors.blueGrey, (t) => FormCalc(t, const [
    F('Number', '255', text: true),
    F('Input base', 'Decimal', opts: ['Binary', 'Octal', 'Decimal', 'Hexadecimal']),
  ], (v) {
    final b = BigInt.parse(v[0].trim(), radix: radix[v[1]]!);
    return [
      R('Decimal (Base 10)', b.toString()),
      R('Binary (Base 2)', b.toRadixString(2)),
      R('Octal (Base 8)', b.toRadixString(8)),
      R('Hexadecimal (Base 16)', b.toRadixString(16).toUpperCase()),
    ];
  })),
  Tool('Equation Solver', 'দ্বিঘাত সমীকরণ', Icons.functions, Colors.deepPurple, (t) => FormCalc(t, const [
    F('a  (ax² + bx + c = 0)', '1'),
    F('b', '-5'),
    F('c', '6'),
  ], (v) {
    final a = n(v[0]), b = n(v[1]), c = n(v[2]);
    if (a == 0) {
      if (b == 0) throw 0;
      return [R('Linear equation: x', fmt(-c / b)), const R('Note', 'a = 0, so equation is linear')];
    }
    final d = b * b - 4 * a * c, vx = -b / (2 * a), vy = a * vx * vx + b * vx + c;
    final vertex = R('Vertex', '(${fmt(vx)}, ${fmt(vy)})');
    if (d >= 0) {
      final s = sqrt(d);
      return [
        R('Roots', 'x₁ = ${fmt((-b + s) / (2 * a))}\nx₂ = ${fmt((-b - s) / (2 * a))}'),
        R('Discriminant (D)', fmt(d)),
        R('Nature', d == 0 ? 'One repeated real root' : 'Two real roots'),
        vertex,
      ];
    }
    return [
      R('Complex roots', 'x = ${fmt(vx)} ± ${fmt(sqrt(-d) / (2 * a.abs()))}i'),
      R('Discriminant (D)', fmt(d)),
      const R('Nature', 'Two complex roots'),
      vertex,
    ];
  })),
  Tool('Random Number', 'র্যান্ডম নম্বর', Icons.casino, Colors.pink.shade400, (t) => FormCalc(t, const [
    F('Min', '1'),
    F('Max', '100'),
    F('How many (1-20)', '1'),
  ], (v) {
    var lo = int.tryParse(v[0].trim()) ?? 1, hi = int.tryParse(v[1].trim()) ?? 100;
    if (lo > hi) {
      final tmp = lo;
      lo = hi;
      hi = tmp;
    }
    final k = max(1, min(20, int.tryParse(v[2].trim()) ?? 1));
    final r = Random();
    final xs = List.generate(k, (_) => lo + r.nextInt(hi - lo + 1));
    return [R('Random number${k > 1 ? 's' : ''}', xs.join(',  ')), R('Range', '$lo – $hi')];
  }, action: 'Roll Again')),
  Tool('Prime Checker', 'মৌলিক সংখ্যা পরীক্ষা', Icons.tag, Colors.lightBlue.shade700, (t) => FormCalc(t, const [
    F('Enter integer N', '97'),
  ], (v) {
    final x = int.parse(v[0].trim());
    if (x.abs() > 1000000000000) throw 0;
    final p = isPrime(x);
    var m = x;
    final f = <int, int>{};
    for (var i = 2; m > 1 && i * i <= m; i++) {
      while (m % i == 0) {
        f[i] = (f[i] ?? 0) + 1;
        m ~/= i;
      }
    }
    if (m > 1) f[m] = (f[m] ?? 0) + 1;
    var nx = x + 1;
    while (!isPrime(nx)) {
      nx++;
    }
    var pv = x - 1;
    while (pv > 1 && !isPrime(pv)) {
      pv--;
    }
    return [
      R('Is $x a prime number?', p ? 'Prime ✓' : 'Not Prime ✗'),
      R('Prime factorization',
          x < 2 ? 'N/A' : f.entries.map((e) => e.value > 1 ? '${e.key}^${e.value}' : '${e.key}').join(' × ')),
      R('Next prime', '$nx'),
      R('Previous prime', pv > 1 ? '$pv' : 'None'),
    ];
  })),
  Tool('Factorial n!', 'ফ্যাক্টোরিয়াল', Icons.numbers, Colors.brown, (t) => FormCalc(t, const [
    F('Enter integer N (0 – 1000)', '10'),
  ], (v) {
    final x = int.parse(v[0].trim());
    if (x < 0 || x > 1000) throw 0;
    var f = BigInt.one;
    for (var i = 2; i <= x; i++) {
      f *= BigInt.from(i);
    }
    final s = f.toString();
    var z = 0, q = 5;
    while (q <= x) {
      z += x ~/ q;
      q *= 5;
    }
    return [
      R('$x!', s),
      R('Number of digits', '${s.length}'),
      R('Trailing zeros', '$z'),
      R('Scientific', s.length > 6 ? '${s[0]}.${s.substring(1, 6)} × 10^${s.length - 1}' : s),
    ];
  })),
];
