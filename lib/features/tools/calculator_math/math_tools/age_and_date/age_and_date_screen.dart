import 'package:all_tools_app/features/tools/calculator_math/math_tools/math_utils/math_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgeAndDateScreen extends StatefulWidget {
  final Tool t;
  final bool age;
  const AgeAndDateScreen(this.t, this.age, {super.key});
  @override
  State<AgeAndDateScreen> createState() => _AgeAndDateScreen();
}

class _AgeAndDateScreen extends State<AgeAndDateScreen> {
  late DateTime a = widget.age ? DateTime(2000, 1, 1) : DateTime.now().subtract(const Duration(days: 30));
  DateTime b = DateTime.now();

  Future<void> _pick(bool first) async {
    final p = await showDatePicker(
        context: context,
        initialDate: first ? a : b,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (p != null) setState(() => first ? a = p : b = p);
  }

  Widget _tile(String l, DateTime d, bool first) => Card(
    margin: EdgeInsets.zero,
    child: ListTile(
      leading: Icon(Icons.event, color: widget.t.color),
      title: Text(l),
      subtitle: Text(DateFormat('dd MMMM yyyy (EEEE)').format(d),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.edit_calendar),
      onTap: () => _pick(first),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bad = widget.age && daysBetween(a, now) < 0;
    var s = a, e = widget.age ? now : b;
    if (daysBetween(s, e) < 0) {
      final x = s;
      s = e;
      e = x;
    }
    var y = e.year - s.year, m = e.month - s.month, d = e.day - s.day;
    if (d < 0) {
      m--;
      d += DateTime(e.year, e.month, 0).day;
    }
    if (m < 0) {
      y--;
      m += 12;
    }
    final total = daysBetween(s, e);
    final res = <R>[];
    if (!bad) {
      if (widget.age) {
        final td = DateTime(now.year, now.month, now.day);
        var nb = DateTime(now.year, a.month, a.day);
        if (nb.isBefore(td)) nb = DateTime(now.year + 1, a.month, a.day);
        res.addAll([
          R('Total months', '${y * 12 + m}'),
          R('Total weeks', '${total ~/ 7}'),
          R('Total days', '$total'),
          R('Total hours', NumberFormat('#,###').format(total * 24)),
          R('Next birthday', '${daysBetween(td, nb)} days • ${DateFormat('EEEE').format(nb)}'),
        ]);
      } else {
        res.addAll([
          R('Weeks & days', '${total ~/ 7} weeks ${total % 7} days'),
          R('Total days', '$total'),
          R('Total hours', NumberFormat('#,###').format(total * 24)),
          R('Approx. months', fmt(total / 30.4375, 1)),
        ]);
      }
    }
    return Pg(widget.t, [
      _tile(widget.age ? 'Date of Birth' : 'From', a, true),
      if (!widget.age) _tile('To', b, false),
      hero(widget.t, widget.age ? 'Your exact age' : 'Difference', bad ? 'Invalid date' : '${y}y ${m}m ${d}d'),
      if (res.isNotEmpty) rows(res),
    ]);
  }
}
