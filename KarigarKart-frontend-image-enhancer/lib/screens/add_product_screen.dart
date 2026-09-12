import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/app_state.dart';
import '../theme.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final selected = await ImagePicker().pickImage(
        source: source,
        imageQuality: 92,
        maxWidth: 2400,
      );
      if (selected == null || !context.mounted) return;
      AppScope.of(context).selectProductImage(selected.path);
      Navigator.pushNamed(context, '/preview');
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Could not open the camera or gallery. Check app permissions.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Add a product')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Show us your craft',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Choose a photo. AI will remove the background, improve the lighting and prepare a marketplace-ready image.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 28),
            _PickOption(
              icon: Icons.camera_alt_outlined,
              title: 'Take a photo',
              subtitle: 'Use your camera to capture your product',
              onTap: () => _pickImage(context, ImageSource.camera),
            ),
            _PickOption(
              icon: Icons.photo_library_outlined,
              title: 'Choose from gallery',
              subtitle: 'Select an existing JPEG, PNG or WebP photo',
              onTap: () => _pickImage(context, ImageSource.gallery),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.saffron.withValues(alpha: .13),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.tips_and_updates_outlined, color: AppColors.clay),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Use natural light, keep the full product visible and hold the phone steady.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _PickOption extends StatelessWidget {
  const _PickOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 14),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.cream,
            child: Icon(icon, color: AppColors.clay),
          ),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(subtitle),
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      );
}
