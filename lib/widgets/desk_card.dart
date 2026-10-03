import 'package:flutter/material.dart';

class DeskCard extends StatelessWidget {
  const DeskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF30363D)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF8B949E)),
            ],
          ),
        ),
      ),
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({super.key, required this.label, required this.value, this.ok});

  final String label;
  final String value;
  final bool? ok;

  @override
  Widget build(BuildContext context) {
    final color = ok == null
        ? const Color(0xFF00E5FF)
        : (ok! ? const Color(0xFF3FB950) : const Color(0xFFD29922));
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF30363D)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(),
                style: const TextStyle(fontSize: 10, letterSpacing: 1.2, color: Color(0xFF8B949E))),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}
