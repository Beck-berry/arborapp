import 'package:arborapp/src/enums.dart';
import 'package:arborapp/src/types.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'applicationState.dart';

class Plant extends StatelessWidget {
  const Plant({
    required this.noveny,
    super.key
  });

  final NovenyAdat noveny;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    appState.megnyitottNoveny = noveny.id;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            noveny.nev,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(10.0),
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
            const Divider(
              color: Colors.grey,
            ),
            Column(
              children: [
                Meret(meret: noveny.meret),
                KornyezetiIgenyek(igenyek: noveny.igenyek),
                Diszitoertek(diszitoertek: noveny.diszitoertek),
                Alkalmazas(alkalmazas: noveny.alkalmazas),
              ],
            ),
            /*SizedBox(
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
            ),*/
            const Divider(
              color: Colors.grey,
            ),
            Jegyzet(
              novenyId: noveny.id,
            )
          ]
        )
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
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
                    fontSize: 12,
                  ),
                ),
              ]
              ),
            Row(
              children: [
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
                    fontSize: 12,
                  ),
                ),
              ],
            ),
           Row(
             children: [
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
                 child: Image.asset(
                   'assets/images/ido.png',
                   height: 25
                 ),
               ),
                Text(
                  "${meret['ido']} év",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              ],
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
              fontSize: 15,
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
            Text(
                "pH: ${igenyek['talaj']}",
                style: const TextStyle(
                    fontSize: 10
                )
            )
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
              fontSize: 15,
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
                      fontSize: 13,
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
                      fontSize: 13,
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
                      fontSize: 13,
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
                      fontSize: 13,
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
              fontSize: 15,
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

class Jegyzet extends StatefulWidget {
  const Jegyzet({
    required this.novenyId,
    super.key
  });

  final DocumentReference novenyId;

  @override
  _JegyzetState createState() => _JegyzetState();
}

class _JegyzetState extends State<Jegyzet> {
  NoteState _noteState = NoteState.show;
  bool _showMentesBtn = false;
  String _szoveg = '';
  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);

    if (appState.loginState != LoginState.loggedIn) {
      return const Text(
          "Jegyzetet írhatsz a növényhez, miután bejelentkeztél.");
    }

    // csak ehhez a növényhez tartozó jegyzet megjelenítése
    bool vanJegyzet = appState.jegyzetek.isNotEmpty && appState.jegyzetek.any((j) => j.noveny == appState.megnyitottNoveny);
    if (!vanJegyzet) {
      return ElevatedButton(
          onPressed: () {
            setState(() {
              _noteState = NoteState.write;
            });
          },
          child: const Text("Jegyzet írása")
      );
    }

    JegyzetAdat? jegyzet = appState.jegyzetek.firstWhere((j) => j.noveny == appState.megnyitottNoveny);

    switch (_noteState) {
      case NoteState.write:
        return Column(
          children: [
            TextField(
              minLines: 5,
              maxLines: 15,
              onSubmitted: (value) {
                _szoveg = value;
                setState(() {
                  _showMentesBtn = true;
                });
              },
            ),
            if (_showMentesBtn) ...[ ElevatedButton(
                onPressed: () {
                  appState.saveNote(widget.novenyId, _szoveg);
                  setState(() {
                    _noteState = NoteState.show;
                    _showMentesBtn = false;
                  });
                },
                child: const Text("Mentés")
              )
            ]
          ],
        );
      case NoteState.modify:
        return Column(
          children: [
            TextFormField(
              minLines: 5,
              maxLines: 15,
              controller: _controller
            ),
            ElevatedButton(
              onPressed: () {
                appState.modifyNote(jegyzet.id, _controller.value.text);
                setState(() {
                  _noteState = NoteState.show;
                });
                _controller.clear();
              },
              child: const Text("Mentés")
            )
          ],
        );
      default:
        return Column(
          children: [
            const Text(
              "Saját feljegyzések",
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              jegyzet.szoveg,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                      children: [
                        const Text(
                          "Módosítva:",
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          "${jegyzet.modositva.year}.${jegyzet.modositva
                              .month}.${jegyzet.modositva.day}. ${jegyzet
                              .modositva.hour}:${jegyzet.modositva.minute}",
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )
                ),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _noteState = NoteState.modify;
                            _controller = TextEditingController(text: jegyzet.szoveg);
                          });
                        },
                        child: const Text("Szerkesztés")
                    )
                )
              ],
            )
          ],
        );
    }
  }
}