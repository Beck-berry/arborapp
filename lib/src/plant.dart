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
                  child: Meret(meret: noveny.meret)
              ),
              TableCell(
                  child: KornyezetiIgenyek(igenyek: noveny.igenyek)
              ),
            ]
        ),
        TableRow(
            children: [
              TableCell(
                  child: Diszitoertek(diszitoertek: noveny.diszitoertek)
              ),
              TableCell(
                  child: Alkalmazas(alkalmazas: noveny.alkalmazas)
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
                'assets/images/tree.jpg',
                height: 40
            ),
            Text(meret['magassag']),
            Image.asset(
                'assets/images/tree.jpg',
                height: 40
            ),
            Text(meret['szelesseg']),
            Image.asset(
                'assets/images/tree.jpg',
                height: 40
            ),
            Text(meret['ido'])
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
            Text(igenyek['fenyigeny'],
                style: const TextStyle(
                fontSize: 10
            ))
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
        Row(
          children: [
            Text(diszitoertek['tavasz']),
            Text(diszitoertek['nyar']),
            Text(diszitoertek['osz']),
            Text(diszitoertek['tel'])
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