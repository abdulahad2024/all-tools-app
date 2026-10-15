import 'package:all_tools_app/features/tools/calculator_math/math_tools/math_utils/math_utils.dart';
import 'package:flutter/material.dart';

class _Sub {
  String credit = '3', grade = 'A+';
}

const gp = <String, double>{
  'A+': 4.0, 'A': 3.75, 'A-': 3.5, 'B+': 3.25, 'B': 3.0, 'B-': 2.75, 'C+': 2.5, 'C': 2.25, 'D': 2.0, 'F': 0.0,
};

class CgpaGpaScreen extends StatefulWidget {
  final Tool t;
  const CgpaGpaScreen(this.t, {super.key});
  @override
  State<CgpaGpaScreen> createState() => _CgpaGpaScreen();
}

class _CgpaGpaScreen extends State<CgpaGpaScreen> {
  final subs = [_Sub(), _Sub(), _Sub()];
  String pc = '0', pg = '0';

  @override
  Widget build(BuildContext context) {
    double tc = 0, pts = 0;
    for (final s in subs) {
      final c = n(s.credit);
      tc += c;
      pts += c * gp[s.grade]!;
    }
    final pcr = n(pc), all = tc + pcr;
    final cg = all > 0 ? (pts + pcr * n(pg)) / all : 0.0;
    return Pg(widget.t, [
      for (var i = 0; i < subs.length; i++)
        Row(key: ObjectKey(subs[i]), children: [
          CircleAvatar(radius: 14, child: Text('${i + 1}')),
          const SizedBox(width: 10),
          Expanded(flex: 2, child: tf('Credit', subs[i].credit, (x) => setState(() => subs[i].credit = x))),
          const SizedBox(width: 10),
          Expanded(flex: 3, child: dd('Grade', subs[i].grade, gp.keys.toList(), (x) => setState(() => subs[i].grade = x))),
          IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: subs.length > 1 ? () => setState(() => subs.removeAt(i)) : null),
        ]),
      OutlinedButton.icon(
          onPressed: () => setState(() => subs.add(_Sub())),
          icon: const Icon(Icons.add),
          label: const Text('Add Subject')),
      Row(children: [
        Expanded(child: tf('Previous CGPA', pg, (x) => setState(() => pg = x))),
        const SizedBox(width: 10),
        Expanded(child: tf('Previous Credits', pc, (x) => setState(() => pc = x))),
      ]),
      hero(widget.t, 'Semester GPA', fmt(tc > 0 ? pts / tc : 0.0, 2)),
      rows([
        R('CGPA (with previous)', fmt(cg, 2)),
        R('Semester credits', fmt(tc)),
        R('Total credits', fmt(all)),
        R('Quality points', fmt(pts, 2)),
      ]),
    ]);
  }
}