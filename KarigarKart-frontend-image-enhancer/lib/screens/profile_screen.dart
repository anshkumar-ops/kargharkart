import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.embedded = false});
  final bool embedded;
  @override
  Widget build(BuildContext context) => SafeArea(
          child: ListView(children: [
        const PageHeader(
            title: 'Profile & settings',
            subtitle: 'Manage your artisan storefront'),
        Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.saffron.withValues(alpha: .3),
                  child: const Icon(Icons.person,
                      color: AppColors.clay, size: 32)),
              const SizedBox(width: 14),
              const Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Asha Devi',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w800)),
                    Text('Madhubani, Bihar',
                        style: TextStyle(color: AppColors.muted))
                  ])),
              const Icon(Icons.verified, color: AppColors.forest)
            ])),
        _Setting(
            icon: Icons.language,
            title: 'App language',
            subtitle: AppScope.of(context).language),
        _Setting(
            icon: Icons.storefront_outlined,
            title: 'Shop details',
            subtitle: 'Asha Handicrafts'),
        _Setting(
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'Orders and product updates'),
        _Setting(
            icon: Icons.help_outline,
            title: 'Help & support',
            subtitle: 'Get assistance in your language'),
        Padding(
            padding: const EdgeInsets.all(20),
            child: OutlinedButton.icon(
                onPressed: () {
                  AppScope.of(context).logout();
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'))),
      ]));
}

class _Setting extends StatelessWidget {
  const _Setting(
      {required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => ListTile(
      leading: CircleAvatar(
          backgroundColor: AppColors.cream,
          child: Icon(icon, color: AppColors.clay)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle));
}
