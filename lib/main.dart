import 'package:flutter/material.dart';
import 'atelier1.dart';
import 'atelier2.dart';
import 'atelier3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Material 3',
      theme: ThemeData(useMaterial3: true),
      home: const ProductDetailPage(
        product: Product(
          'iPhone 15', 
          999, 
          'https://picsum.photos/200/300', 
          isNew: true, 
          rating: 4.5
        ),
      ),
    );
  }
}