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
      home: const MyHomePage(cim: 'Arborapp'),
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
        body: Column(
          children: [
            const Icon(
              Icons.forest,
              size: 100,
              color: Colors.green,
            ),
             Container(
               margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
               child:
                 const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla elementum tempor dolor id varius. Nulla dictum ipsum sit amet elit tincidunt, at iaculis ex condimentum. In hac habitasse platea dictumst. Cras vitae metus aliquet eros ornare egestas id non ipsum. Maecenas lobortis pretium libero, vel scelerisque erat eleifend nec. Nullam rhoncus nisi id justo vehicula efficitur. Quisque erat sapien, maximus a metus non, ullamcorper tincidunt nibh.',
                    textAlign: TextAlign.justify,
                )
             ),
            const FoMenuButton(
              cimke: "Barangolás a térképen",
              ikon: Icons.map,
              onPress: Plant(),
            ),
            const FoMenuButton(
              cimke: "Növény keresése",
              ikon: Icons.search,
              onPress: Plant(),
            ),
            const FoMenuButton(
              cimke: "Saját jegyzeteim",
              ikon: Icons.edit,
              onPress: Plant(),
            ),
            const FoMenuButton(
              cimke: "Profil beállítások",
              ikon: Icons.face,
              onPress: Plant(),
            ),
          ]
        )
    );
  }
}

class FoMenuButton extends StatelessWidget {
  const FoMenuButton({Key? key, required this.cimke, required this.ikon, required this.onPress}) : super(key: key);

  final String cimke;
  final IconData ikon;
  final Widget onPress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
        ElevatedButton.icon(
          label: Text(cimke),
          icon: Icon(ikon, size: 20),
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(300, 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => onPress)
            );
          }
        ),
    );
  }
}