import 'package:flutter/material.dart';

import 'src/plant.dart';

void main() {
  runApp(const Arborapp());
}

class Arborapp extends StatelessWidget {
  const Arborapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arborapp',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(cim: 'Arborapp Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.cim}) : super(key: key);

  final String cim;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(cim),
        ),
        body: const Plant()
    );
  }
}