import 'package:flutter/material.dart';

LinearGradient deviceGrad(Color c) => LinearGradient(
      colors: [c, Color.lerp(c, Colors.black, 0.35)!],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

Widget deviceHero(String title, String subtitle, Color color, IconData icon) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: deviceGrad(color),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
      ],
    ),
    child: Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white24,
          radius: 28,
          child: Icon(icon, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    ),
  );
}
