import 'package:flutter/material.dart';
import 'atelier6.dart'; // Import de l'atelier 6

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nos Produits',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const ProductListPageM6(), // Page d'accueil de l'atelier 6
    );
  }
}