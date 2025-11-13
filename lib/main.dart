import 'package:flutter/material.dart';
import 'atelier2.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atelier 4 - Navigation',
      theme: ThemeData(useMaterial3: true),
      home: const ProductListPageM3(), // Test de l'atelier 4
    );
  }
}