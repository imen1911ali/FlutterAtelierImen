import 'package:flutter/material.dart';

// Ce fichier démontre les modifications de l'atelier 4
class Atelier4Demo extends StatelessWidget {
  const Atelier4Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atelier 4 - Démonstration'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modifications de l\'Atelier 4:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('✅ 1. Importation réciproque des fichiers'),
            Text('✅ 2. InkWell pour rendre les cartes cliquables'),
            Text('✅ 3. Navigator.push pour la navigation'),
            Text('✅ 4. Utilisation des images locales'),
            SizedBox(height: 32),
            Text(
              'Testez en lançant l\'application sur ProductListPageM3',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}