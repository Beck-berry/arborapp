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
            shrinkWrap: true,
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
              Meret(meret: noveny.meret),
              KornyezetiIgenyek(igenyek: noveny.igenyek),
              Diszitoertek(diszitoertek: noveny.diszitoertek),
              Alkalmazas(alkalmazasString: noveny.alkalmazas),
              OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(noveny.nev),
                        content: Container(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) {
                              return Image.asset(
                                'assets/images/tree.jpg', // TODO idetartozo kepek
                              );
                            },
                          ),
                        ),
                      );
                    }
                  );
                },
                child: const Text("További képek megtekintése"),
              ),
              const Divider(
                color: Colors.grey,
              ),
              Jegyzet(novenyId: noveny.id)
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
        Row(
          children: [
            Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                            "Tavasz:",
                            style: TextStyle(
                              fontSize: 13,
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
                    )
                  ],
                )
            ),
            Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                            "Ősz:",
                            style: TextStyle(
                              fontSize: 13,
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
            ),
          ]
        ),
      ],
    );
  }
}

class Alkalmazas extends StatelessWidget {
  const Alkalmazas({
    required this.alkalmazasString,
    super.key
  });

  final String alkalmazasString;

  @override
  Widget build(BuildContext context) {
    List<String> alkalmazas = alkalmazasString.split(', ');

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
            const Text("|| "),
            for (String a in alkalmazas) ...[
              Text(a),
              const Text(" || ")
            ]
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
      if (_noteState == NoteState.show) {
        return ElevatedButton(
            onPressed: () {
              setState(() {
                _noteState = NoteState.write;
              });
              _controller = TextEditingController();
            },
            child: const Text("Jegyzet írása")
        );
      } else if (_noteState == NoteState.write) {
        return Column(
          children: [
            TextFormField(
              minLines: 5,
              maxLines: 15,
              autofocus: true,
              controller: _controller
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _noteState = NoteState.show;
                  });
                },
                child: const Text("Mégsem")
            ),
            ElevatedButton(
                onPressed: () {
                  appState.saveNote(widget.novenyId, _controller.value.text);
                  _controller.clear();
                  setState(() {
                    _noteState = NoteState.show;
                  });
                },
                child: const Text("Mentés")
            )
          ],
        );
      }
    }

    JegyzetAdat? jegyzet = appState.jegyzetek.firstWhere((j) => j.noveny == appState.megnyitottNoveny);

    if (_noteState == NoteState.modify) {
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
    }

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
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  appState.deleteNote(jegyzet.id);
                  setState(() {
                    _noteState = NoteState.show;
                  });
                },
                child: const Text("Törlés")
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