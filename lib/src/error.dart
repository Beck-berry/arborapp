import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({required this.hiba, super.key});

  final Object? hiba;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(hiba);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Hiba történt'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: const Icon(
                    Icons.emoji_objects_outlined,
                    size: 100,
                    semanticLabel: 'Error',
                    color: Colors.redAccent,
                  ),
                ),
                const Text(
                  'Hiba történt a kérés folyamán. Kérünk, próbáld meg újra, vagy jelezd a problémát az alábbi címen: arborapp.info@gmail.com',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            )));
  }
}
