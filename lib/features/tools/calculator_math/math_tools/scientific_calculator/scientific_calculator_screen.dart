
import 'package:all_tools_app/features/tools/calculator_math/math_tools/math_utils/math_utils.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class ScientificCalculatorScreen extends StatefulWidget {
  final Tool t;
  const ScientificCalculatorScreen(this.t, {super.key});
  @override
  State<ScientificCalculatorScreen> createState() => _ScientificCalculatorScreen();
}

class _ScientificCalculatorScreen extends State<ScientificCalculatorScreen> {
  String _e = '', _h = '';
  bool _sci = false, _deg = true, _done = false;
  static const _fns = {'sin', 'cos', 'tan', 'log', 'ln', 'sqrt'};
  static const _ops = '÷×−+^';

  String _wrap(String s, String f, String pre, String post) {
    var i = 0;
    while ((i = s.indexOf('$f(', i)) != -1) {
      final st = i + f.length + 1;
      var j = st, d = 1;
      while (j < s.length && d > 0) {
        if (s[j] == '(') {
          d++;
        } else if (s[j] == ')') {
          d--;
        }
        j++;
      }
      s = s.substring(0, i) + pre + s.substring(st, j - 1) + post + s.substring(j);
      i += pre.length;
    }
    return s;
  }

  String? _eval(String e) {
    if (e.isEmpty) return null;
    try {
      var s = e;
      final open = '('.allMatches(s).length - ')'.allMatches(s).length;
      if (open > 0) s += ')' * open;
      s = s.replaceAllMapped(RegExp(r'([\d\)πe])(?=[(πesctl])|([\)πe])(?=\d)'), (m) => '${m[0]}*');
      s = s
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-')
          .replaceAll('%', '/100')
          .replaceAll('π', '3.141592653589793')
          .replaceAll('e', '2.718281828459045');
      if (_deg) {
        for (final f in ['sin', 'cos', 'tan']) {
          s = _wrap(s, f, '$f((', ')*0.017453292519943295)');
        }
      }
      s = _wrap(s, 'log', '(0.4342944819032518*ln(', '))');
      final v = ShuntingYardParser().parse(s).evaluate(EvaluationType.REAL, ContextModel());
      final d = (v as num).toDouble();
      return d.isFinite ? fmt(d, 8) : null;
    } catch (_) {
      return null;
    }
  }

  void _press(String t) {
    setState(() {
      if (t == 'C') {
        _e = '';
        _h = '';
        _done = false;
      } else if (t == '⌫') {
        if (_done) {
          _e = '';
          _done = false;
        } else if (_e.isNotEmpty) {
          _e = _e.substring(0, _e.length - 1);
        }
      } else if (t == '=') {
        final r = _eval(_e);
        if (r != null) {
          _h = '$_e =';
          _e = r;
          _done = true;
        } else if (_e.isNotEmpty) {
          _h = 'Invalid expression';
        }
      } else if (t == 'DEG' || t == 'RAD') {
        _deg = !_deg;
      } else {
        final isOp = _ops.contains(t) || t == '%';
        if (_done && !isOp) _e = '';
        _done = false;
        var add = _fns.contains(t) ? '$t(' : t;
        if (t == '( )') {
          final o = '('.allMatches(_e).length, c = ')'.allMatches(_e).length;
          final last = _e.isEmpty ? '' : _e[_e.length - 1];
          add = (_e.isEmpty || _ops.contains(last) || last == '(') ? '(' : (o > c ? ')' : '(');
        }
        _e += add;
        _h = '';
      }
    });
  }

  Widget _line(String s, double size, Color c, [bool bold = false]) => FittedBox(
    fit: BoxFit.scaleDown,
    alignment: Alignment.centerRight,
    child: Text(s,
        maxLines: 1,
        style: TextStyle(fontSize: size, color: c, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
  );

  Widget _btn(String t, ColorScheme cs) {
    Color bg = cs.surfaceContainerHighest, fg = cs.onSurface;
    if (t == '=') {
      bg = cs.primary;
      fg = cs.onPrimary;
    } else if (t == 'C') {
      bg = cs.errorContainer;
      fg = cs.onErrorContainer;
    } else if (t == '⌫') {
      bg = cs.secondaryContainer;
      fg = cs.onSecondaryContainer;
    } else if (_ops.contains(t) || t == '%') {
      bg = cs.primaryContainer;
      fg = cs.onPrimaryContainer;
    } else if (_fns.contains(t) || const ['π', 'e', 'DEG', 'RAD', '(', ')'].contains(t)) {
      bg = cs.tertiaryContainer;
      fg = cs.onTertiaryContainer;
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: bg,
              foregroundColor: fg,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
          onPressed: () => _press(t),
          child: FittedBox(
              child: Text(t == 'sqrt' ? '√' : t, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final prev = _done ? null : _eval(_e);
    final keys = <List<String>>[
      if (_sci) ...[
        [_deg ? 'DEG' : 'RAD', 'sin', 'cos', 'tan'],
        ['log', 'ln', 'sqrt', '^'],
        ['π', 'e', '(', ')'],
      ],
      ['C', '⌫', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
      ['( )', '0', '.', '='],
    ];
    return Scaffold(
      appBar: bar(widget.t, actions: [
        IconButton(
            tooltip: 'Scientific mode',
            icon: Icon(_sci ? Icons.calculate : Icons.functions),
            onPressed: () => setState(() => _sci = !_sci)),
      ]),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: grad(widget.t.color), borderRadius: BorderRadius.circular(28)),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: [
                _line(_h, 18, Colors.white60),
                _line(_e.isEmpty ? '0' : _e, 44, Colors.white, true),
                _line(prev != null && prev != _e ? '= $prev' : '', 24, Colors.white70),
              ]),
            ),
          ),
          Expanded(
            flex: _sci ? 9 : 6,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(children: [
                for (final r in keys) Expanded(child: Row(children: [for (final b in r) _btn(b, cs)])),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
