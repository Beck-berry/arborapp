import 'package:flutter/material.dart';

class Plant extends StatelessWidget {
  const Plant({
    required this.noveny,
    super.key
  });

  final NovenyAdat noveny;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            noveny.nev,
          ),
        ),
        body: Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
                children: [
                  IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Image.asset('assets/images/tree.jpg')
                          ),
                          Expanded(
                              flex: 3,
                              child: Text(
                                noveny.leiras,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              )
                          )
                        ],
                      )
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: AdatTabla(noveny: noveny)
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          Image.asset(
                              'assets/images/tree.jpg',
                              height: 110
                          ),
                          Image.asset(
                              'assets/images/tree.jpg',
                              height: 110
                          ),
                          Image.asset(
                              'assets/images/tree.jpg',
                              height: 110
                          ),
                          Image.asset(
                              'assets/images/tree.jpg',
                              height: 110
                          ),
                          Image.asset(
                              'assets/images/tree.jpg',
                              height: 110
                          ),
                        ],
                      )
                  ),
                ]
            )
        )
    );
  }
}

class NovenyAdat {
  NovenyAdat({
    required this.nev,
    required this.leiras,
    required this.meret,
    required this.igenyek,
    required this.diszitoertek,
    required this.alkalmazas
  });

  final String nev;
  final String leiras;
  final Map<String, dynamic> meret;
  final Map<String, dynamic> igenyek;
  final Map<String, dynamic> diszitoertek;
  final String alkalmazas; // TODO ez lista
}

class AdatTabla extends StatelessWidget {
  const AdatTabla ({
    required this.noveny,
    super.key
  });

  final NovenyAdat noveny;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.symmetric(
        outside: BorderSide.none,
        inside: const BorderSide(width: 2, color: Colors.grey, style: BorderStyle.solid)
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
            children: [
              TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Meret(meret: noveny.meret)
                  )
              ),
              TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: KornyezetiIgenyek(igenyek: noveny.igenyek)
                  )
              ),
            ]
        ),
        TableRow(
            children: [
              TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Diszitoertek(diszitoertek: noveny.diszitoertek)
                  )
              ),
              TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Alkalmazas(alkalmazas: noveny.alkalmazas)
                  )
              )
            ]
        ),
      ],
    );
  }
}

class Meret extends StatelessWidget {
  const Meret({
    required this.meret,
    super.key
  });

  final Map<String, dynamic> meret;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
            "Méret:",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            )
        ),
        Row(
          children: [
            Image.asset(
                'assets/images/fa.png',
                height: 30
            ),
            RotatedBox(
              quarterTurns: 1,
              child: Image.asset(
                  'assets/images/nyil.png',
                  height: 10
              ),
            ),
            Text(
              "${meret['magassag']}m",
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
            Column(
              children: [
                Image.asset(
                    'assets/images/fa.png',
                    height: 30
                ),
                Image.asset(
                    'assets/images/nyil.png',
                    height: 10
                ),
              ]
            ),
            Text(
              "${meret['szelesseg']}m",
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                  'assets/images/ido.png',
                  height: 25
              ),
            ),
            Text(
              "${meret['ido']} év",
              style: const TextStyle(
                fontSize: 10,
              ),
            )
          ],
        )
      ],
    );
  }
}

class KornyezetiIgenyek extends StatelessWidget {
  const KornyezetiIgenyek({
    required this.igenyek,
    super.key
  });

  final Map<String, dynamic> igenyek;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
            "Környezeti igény:",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            )
        ),
        Row(
          children: [
            if (igenyek['fenyigeny'].toString().contains("napos")) ...[
              Image.asset(
                  "assets/images/napos.png",
                  height: 35
              )
            ],
            if (igenyek['fenyigeny'].toString().contains("félárnyékos")) ...[
              Image.asset(
                  "assets/images/felarnyekos.png",
                  height: 35
              )
            ],
          ],
        ),
        Row(
          children: [
            Text("pH: ${igenyek['talaj']}",
                style: const TextStyle(
                    fontSize: 10
                ))
          ],
        )
      ],
    );
  }
}

class Diszitoertek extends StatelessWidget {
  const Diszitoertek({
    required this.diszitoertek,
    super.key
  });

  final Map<String, dynamic> diszitoertek;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
            "Díszítőérték:",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            )
        ),
        Column(
          children: [
            Row(
              children: [
                const Text(
                    "Tavasz:",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    )
                ),
                if (diszitoertek['tavasz'].toString().contains("virág")) ...[
                  Image.asset(
                      "assets/images/virag.png",
                      height: 15
                  )
                ],
                if (diszitoertek['tavasz'].toString().contains("lomb")) ...[
                  Image.asset(
                      "assets/images/level.png",
                      height: 15
                  )
                ],
                if (diszitoertek['tavasz'].toString().contains("termés")) ...[
                  Image.asset(
                      "assets/images/termes.png",
                      height: 15
                  )
                ],
              ],
            ),
            Row(
              children: [
                const Text(
                    "Nyár:",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    )
                ),
                if (diszitoertek['nyar'].toString().contains("virág")) ...[
                  Image.asset(
                      "assets/images/virag.png",
                      height: 15
                  )
                ],
                if (diszitoertek['nyar'].toString().contains("lomb")) ...[
                  Image.asset(
                      "assets/images/level.png",
                      height: 15
                  )
                ],
                if (diszitoertek['nyar'].toString().contains("termés")) ...[
                  Image.asset(
                      "assets/images/termes.png",
                      height: 15
                  )
                ],
              ],
            ),
            Row(
              children: [
                const Text(
                    "Ősz:",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    )
                ),
                if (diszitoertek['osz'].toString().contains("virág")) ...[
                  Image.asset(
                      "assets/images/virag.png",
                      height: 15
                  )
                ],
                if (diszitoertek['osz'].toString().contains("lomb")) ...[
                  Image.asset(
                      "assets/images/level.png",
                      height: 15
                  )
                ],
                if (diszitoertek['osz'].toString().contains("termés")) ...[
                  Image.asset(
                      "assets/images/termes.png",
                      height: 15
                  )
                ],
              ],
            ),
            Row(
              children: [
                const Text(
                    "Tél:",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    )
                ),
                if (diszitoertek['tel'].toString().contains("virág")) ...[
                  Image.asset(
                      "assets/images/virag.png",
                      height: 15
                  )
                ],
                if (diszitoertek['tel'].toString().contains("lomb")) ...[
                  Image.asset(
                      "assets/images/level.png",
                      height: 15
                  )
                ],
                if (diszitoertek['tel'].toString().contains("termés")) ...[
                  Image.asset(
                      "assets/images/termes.png",
                      height: 15
                  )
                ],
              ],
            ),
          ],
        )
      ],
    );
  }
}

class Alkalmazas extends StatelessWidget {
  const Alkalmazas({
    required this.alkalmazas,
    super.key
  });

  final String alkalmazas;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
            "Alkalmazási lehetőségek:",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            )
        ),
        Row(
          children: [
            Text(alkalmazas),
          ],
        )
      ],
    );
  }
}