import 'package:flutter/material.dart';
import '../theme.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink)),
          if (subtitle != null)
            Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(subtitle!,
                    style: const TextStyle(color: AppColors.muted))),
        ]),
      );
}

class ProductVisual extends StatelessWidget {
  const ProductVisual(
      {super.key,
      required this.color,
      this.size = 100,
      this.icon = Icons.inventory_2_outlined});
  final Color color;
  final double size;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            color: color.withValues(alpha: .18),
            borderRadius: BorderRadius.circular(18)),
        child: Icon(icon, color: color, size: size * .45),
      );
}

class StatPill extends StatelessWidget {
  const StatPill({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
            color: AppColors.cream, borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: AppColors.forest),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))
        ]),
      );
}
