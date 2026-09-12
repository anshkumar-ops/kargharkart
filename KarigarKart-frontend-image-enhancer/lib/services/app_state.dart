import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme.dart';

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  String language = 'English';
  String? originalImagePath;
  Uint8List? enhancedImageBytes;
  Product draft = Product(
      id: 'draft',
      title: '',
      description: '',
      price: 1499,
      category: 'Textiles',
      color: AppColors.clay,
      published: false);
  final List<Product> products = [
    Product(
        id: '1',
        title: 'Indigo Block Print Stole',
        description:
            'Hand block printed cotton stole made with natural indigo dyes.',
        price: 1299,
        category: 'Textiles',
        color: const Color(0xFF426B93),
        stock: 4),
    Product(
        id: '2',
        title: 'Terracotta Planter',
        description: 'Earthy, hand-thrown planter with a warm matte finish.',
        price: 899,
        category: 'Pottery',
        color: const Color(0xFFC86B42),
        stock: 7),
    Product(
        id: '3',
        title: 'Cane Storage Basket',
        description: 'Durable handwoven cane basket for everyday spaces.',
        price: 1599,
        category: 'Basketry',
        color: const Color(0xFFB78A4A),
        stock: 2),
  ];

  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  void setLanguage(String value) {
    language = value;
    notifyListeners();
  }

  void selectProductImage(String path) {
    originalImagePath = path;
    enhancedImageBytes = null;
    notifyListeners();
  }

  void setEnhancedImage(Uint8List bytes) {
    enhancedImageBytes = bytes;
    draft.imageBytes = bytes;
    notifyListeners();
  }

  void updateDraft(
      {String? title, String? description, int? price, String? category}) {
    if (title != null) draft.title = title;
    if (description != null) draft.description = description;
    if (price != null) draft.price = price;
    if (category != null) draft.category = category;
    notifyListeners();
  }

  void publishDraft() {
    draft.published = true;
    draft.id = DateTime.now().millisecondsSinceEpoch.toString();
    products.insert(0, draft);
    draft = Product(
        id: 'draft',
        title: '',
        description: '',
        price: 1499,
        category: 'Textiles',
        color: AppColors.clay,
        published: false);
    originalImagePath = null;
    enhancedImageBytes = null;
    notifyListeners();
  }

  void saveProduct(Product product) => notifyListeners();
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
