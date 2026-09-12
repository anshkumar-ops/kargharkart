import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../services/image_enhancement_service.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class ImagePreviewScreen extends StatefulWidget {
  const ImagePreviewScreen({super.key});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  final _service = const ImageEnhancementService();
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _enhance());
  }

  Future<void> _enhance() async {
    final state = AppScope.of(context);
    final path = state.originalImagePath;
    if (path == null) {
      setState(() {
        _loading = false;
        _error = 'No product photo was selected.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final enhanced = await _service.enhance(path);
      if (!mounted) return;
      state.setEnhancedImage(enhanced);
      setState(() => _loading = false);
    } on ImageEnhancementException catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final originalPath = state.originalImagePath;
    final enhanced = state.enhancedImageBytes;

    return Scaffold(
      appBar: AppBar(title: const Text('AI photo enhancement')),
      body: Column(
        children: [
          const PageHeader(
            title: 'A cleaner first impression',
            subtitle: 'Compare the original with the marketplace-ready image.',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cards = [
                    Expanded(
                      child: _ImageCard(
                        label: 'Original',
                        child: originalPath == null
                            ? const Icon(Icons.broken_image_outlined, size: 54)
                            : Image.file(
                                File(originalPath),
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.broken_image_outlined,
                                  size: 54,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth >= 650 ? 14 : 0,
                      height: constraints.maxWidth >= 650 ? 0 : 14,
                    ),
                    Expanded(
                      child: _ImageCard(
                        label: 'Background removed',
                        highlighted: enhanced != null,
                        child: _enhancedContent(enhanced),
                      ),
                    ),
                  ];
                  return constraints.maxWidth >= 650
                      ? Row(children: cards)
                      : Column(children: cards);
                },
              ),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _enhance,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                FilledButton(
                  onPressed: enhanced == null || _loading
                      ? null
                      : () => Navigator.pushNamed(context, '/listing'),
                  child: const Text('Use enhanced image'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _loading ? null : () => Navigator.pop(context),
                  child: const Text('Choose another photo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _enhancedContent(Uint8List? enhanced) {
    if (_loading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 14),
          Text('Removing background…', textAlign: TextAlign.center),
          SizedBox(height: 4),
          Text(
            'The first request can take longer',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      );
    }
    if (enhanced != null) {
      return Image.memory(
        enhanced,
        fit: BoxFit.contain,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined),
      );
    }
    return const Icon(Icons.auto_fix_high_outlined,
        size: 58, color: AppColors.muted);
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({
    required this.label,
    required this.child,
    this.highlighted = false,
  });

  final String label;
  final Widget child;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color:
                      highlighted ? AppColors.forest : const Color(0xFFE2D8CF),
                  width: highlighted ? 2 : 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: child,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (highlighted) ...[
                const Icon(Icons.check_circle,
                    size: 17, color: AppColors.forest),
                const SizedBox(width: 5),
              ],
              Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      );
}

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  final form = GlobalKey<FormState>();
  late final TextEditingController title;
  late final TextEditingController description;
  late final TextEditingController price;
  String category = 'Textiles';
  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initialized) return;
    final draft = AppScope.of(context).draft;
    title = TextEditingController(text: draft.title);
    description = TextEditingController(text: draft.description);
    price = TextEditingController(text: draft.price.toString());
    category = draft.category;
    initialized = true;
  }

  @override
  void dispose() {
    if (initialized) {
      title.dispose();
      description.dispose();
      price.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enhanced = AppScope.of(context).enhancedImageBytes;
    return Scaffold(
      appBar: AppBar(title: const Text('Add product details')),
      body: Form(
        key: form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (enhanced != null)
              Container(
                height: 210,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.memory(enhanced, fit: BoxFit.contain),
              ),
            const SizedBox(height: 18),
            const Row(
              children: [
                Icon(Icons.auto_fix_high, size: 18, color: AppColors.forest),
                SizedBox(width: 6),
                Text(
                  'Marketplace image ready',
                  style: TextStyle(
                      color: AppColors.forest, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Product title'),
              validator: (value) =>
                  value!.trim().isEmpty ? 'Add a title' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: description,
              maxLines: 4,
              decoration:
                  const InputDecoration(labelText: 'Product description'),
              validator: (value) =>
                  value!.trim().length < 15 ? 'Add a little more detail' : null,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                'Textiles',
                'Pottery',
                'Jewellery',
                'Basketry',
                'Woodwork'
              ]
                  .map((value) =>
                      DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) => setState(() => category = value!),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Price', prefixText: '₹ '),
              validator: (value) => int.tryParse(value ?? '') == null
                  ? 'Enter a valid price'
                  : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                if (!form.currentState!.validate()) return;
                AppScope.of(context).updateDraft(
                  title: title.text.trim(),
                  description: description.text.trim(),
                  price: int.parse(price.text),
                  category: category,
                );
                Navigator.pushNamed(context, '/publish');
              },
              child: const Text('Review & publish'),
            ),
          ],
        ),
      ),
    );
  }
}

class PublishScreen extends StatelessWidget {
  const PublishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final draft = state.draft;
    final enhanced = state.enhancedImageBytes;
    return Scaffold(
      appBar: AppBar(title: const Text('Publish product')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            if (enhanced != null)
              Container(
                height: 220,
                width: 220,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Image.memory(enhanced, fit: BoxFit.contain),
              )
            else
              const ProductVisual(
                color: AppColors.forest,
                size: 120,
                icon: Icons.check_circle_outline,
              ),
            const SizedBox(height: 24),
            const Text(
              'Ready for your storefront',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              '${draft.title}\n₹${draft.price}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, height: 1.6),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                state.publishDraft();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (_) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Your product is now live in the catalog.')),
                );
              },
              child: const Text('Publish product'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep editing'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
