import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/ui.dart';
import 'catalog_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final products = AppScope.of(context).products;
    return SafeArea(
        child: ListView(padding: const EdgeInsets.only(bottom: 100), children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(children: [
            const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Namaste, Asha',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                  Text('Your craft is reaching farther today.',
                      style: TextStyle(color: AppColors.muted))
                ])),
            CircleAvatar(
                backgroundColor: AppColors.saffron.withValues(alpha: .25),
                child: const Icon(Icons.person, color: AppColors.clay)),
          ])),
      Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.forest, Color(0xFF4D8B76)]),
                  borderRadius: BorderRadius.circular(24)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your shop at a glance',
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    const Text('₹12,480',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800)),
                    const Text('Potential catalog value',
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 16),
                    Row(children: [
                      const Expanded(child: _MiniStat('12', 'Products')),
                      const Expanded(child: _MiniStat('48', 'Views')),
                      Expanded(
                          child: _MiniStat('${products.length}', 'Live now'))
                    ]),
                  ]))),
      const PageHeader(
          title: 'Continue creating',
          subtitle: 'Simple tools built around your craft'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _ActionCard(
            icon: Icons.auto_fix_high,
            title: 'AI Image Studio',
            subtitle:
                'Remove the background and prepare a polished marketplace photo',
            onTap: () => Navigator.pushNamed(context, '/add')),
      ),
      const PageHeader(title: 'Your recent products'),
      ...products.take(2).map((p) => ProductTile(product: p)),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/catalog'),
              child: const Text('View full catalog'))),
    ]));
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat(this.value, this.label);
  final String value, label;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12))
      ]);
}

class _ActionCard extends StatelessWidget {
  const _ActionCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
          height: 155,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: AppColors.clay, size: 28),
            const Spacer(),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 3),
            Text(subtitle,
                style: const TextStyle(color: AppColors.muted, fontSize: 12))
          ])));
}
