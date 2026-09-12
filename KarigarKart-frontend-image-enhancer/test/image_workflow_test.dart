import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karigarkart/screens/add_product_screen.dart';
import 'package:karigarkart/services/app_state.dart';
import 'package:karigarkart/theme.dart';

void main() {
  test('enhanced image stays attached after publishing', () {
    final state = AppState();
    final image = Uint8List.fromList([1, 2, 3, 4]);

    state.selectProductImage('product.jpg');
    state.setEnhancedImage(image);
    state.updateDraft(
      title: 'Test Basket',
      description: 'A handmade basket prepared for the catalog.',
      price: 350,
      category: 'Basketry',
    );
    state.publishDraft();

    expect(state.products.first.title, 'Test Basket');
    expect(state.products.first.imageBytes, image);
    expect(state.originalImagePath, isNull);
    expect(state.enhancedImageBytes, isNull);
  });

  testWidgets('add product offers only camera and gallery image inputs',
      (tester) async {
    await tester.pumpWidget(
      AppScope(
        state: AppState(),
        child: MaterialApp(theme: buildTheme(), home: const AddProductScreen()),
      ),
    );

    expect(find.text('Take a photo'), findsOneWidget);
    expect(find.text('Choose from gallery'), findsOneWidget);
    expect(find.byIcon(Icons.mic_none), findsNothing);
  });
}
