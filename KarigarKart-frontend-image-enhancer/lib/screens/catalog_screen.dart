import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final items = AppScope.of(context).products;
    return SafeArea(
      child: Column(
        children: [
          PageHeader(
            title: 'My catalog',
            subtitle: '${items.length} handcrafted products',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search your catalog',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: items.isEmpty
                ? const _EmptyCatalog()
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, index) =>
                        ProductTile(product: items[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog();

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 52, color: AppColors.muted),
            SizedBox(height: 12),
            Text('Your catalog is waiting for its first craft.'),
          ],
        ),
      );
}

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductDetailsScreen(product: product)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ProductArtwork(product: product, size: 82),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(product.category,
                          style: const TextStyle(color: AppColors.muted)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            '₹${product.price}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.clay,
                            ),
                          ),
                          const Spacer(),
                          StatPill(
                            icon: product.published
                                ? Icons.public
                                : Icons.edit_outlined,
                            label: product.published ? 'Live' : 'Draft',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class ProductArtwork extends StatelessWidget {
  const ProductArtwork({super.key, required this.product, required this.size});
  final Product product;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (product.imageBytes == null) {
      return ProductVisual(color: product.color, size: size);
    }
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8DED5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.memory(product.imageBytes!, fit: BoxFit.contain),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Product details')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(child: ProductArtwork(product: product, size: 260)),
            const SizedBox(height: 24),
            Text(
              product.title,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              '₹${product.price}',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: AppColors.clay,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'About this craft',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(color: AppColors.muted, height: 1.5),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                StatPill(
                    icon: Icons.category_outlined, label: product.category),
                const SizedBox(width: 8),
                StatPill(
                  icon: Icons.inventory_2_outlined,
                  label: '${product.stock} in stock',
                ),
              ],
            ),
          ],
        ),
      );
}
