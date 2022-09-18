import 'dart:async';

import 'package:arborapp/src/enums.dart';
import 'package:arborapp/src/types.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'applicationState.dart';
import 'error.dart';
import 'load.dart';
import 'map.dart';

class Plant extends StatelessWidget {
  const Plant({required this.noveny, super.key});

  final Noveny noveny;

  Future<NovenyAdat> loadNovenyAdat(appState) async {
    return await appState.getNovenyAdat(noveny.id);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);

    return FutureBuilder<NovenyAdat>(
        future: loadNovenyAdat(appState),
        builder: (BuildContext context,
            AsyncSnapshot<NovenyAdat> novenyAdatSnapshot) {
          switch (novenyAdatSnapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingScreen(cim: noveny.nev);
            default:
              if (novenyAdatSnapshot.hasError) {
                return ErrorScreen(hiba: novenyAdatSnapshot.error);
              } else {
                return _ShowNovenyAdat(
                    noveny: noveny, novenyAdat: novenyAdatSnapshot.data);
              }
          }
        });
  }
}

class _ShowNovenyAdat extends StatelessWidget {
  const _ShowNovenyAdat({required this.noveny, required this.novenyAdat});

  final Noveny noveny;
  final NovenyAdat? novenyAdat;

  @override
  Widget build(BuildContext context) {
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
                            novenyAdat!.leiras,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ))
                ],
              )),
              Meret(meret: novenyAdat!.meret),
              KornyezetiIgenyek(igenyek: novenyAdat!.igenyek),
              Diszitoertek(diszitoertek: novenyAdat!.diszitoertek),
              Alkalmazas(alkalmazas: novenyAdat!.alkalmazas),
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
                      });
                },
                child: const Text('További képek megtekintése'),
              ),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Terkep(novenyId: noveny.id)));
                  },
                  child: const Text('Mutasd a térképen!')),
              Jegyzet(novenyId: noveny.id)
            ]));
  }
}

Widget _alCim(String cim) {
  return Container(
    color: Colors.green,
    width: double.maxFinite,
    padding: const EdgeInsets.all(5.0),
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    child: Text(
      cim,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

class Meret extends StatelessWidget {
  const Meret({required this.meret, super.key});

  final Map<String, dynamic> meret;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _alCim('Méret és élettartam'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(children: [
              Image.asset('assets/images/fa.png', height: 30),
              RotatedBox(
                quarterTurns: 1,
                child: Image.asset('assets/images/nyil.png', height: 10),
              ),
              Text(
                "${meret['magassag']}m",
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ]),
            Row(
              children: [
                Column(children: [
                  Image.asset('assets/images/fa.png', height: 30),
                  Image.asset('assets/images/nyil.png', height: 10),
                ]),
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
                  child: Image.asset('assets/images/ido.png', height: 25),
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
        _alCim('Környezeti igények'),
        Row(
          children: [
            if (igenyek['fenyigeny'].contains('napos')) ...[
              Image.asset('assets/images/napos.png', height: 35)
            ],
            if (igenyek['fenyigeny'].contains('felarnyekos')) ...[
              Image.asset('assets/images/felarnyekos.png', height: 35)
            ],
          ],
        ),
        Row(
          children: [
            Text("pH: ${igenyek['talaj']}",
                style: const TextStyle(fontSize: 10))
          ],
        )
      ],
    );
  }
}

class Diszitoertek extends StatelessWidget {
  const Diszitoertek({required this.diszitoertek, super.key});

  final Map<String, dynamic> diszitoertek;

  Widget showLista(List<dynamic> evszak) {
    return Row(
      children: [
        if (evszak.contains('virag')) ...[
          Image.asset('assets/images/virag.png', height: 15)
        ],
        if (evszak.contains('lomb')) ...[
          Image.asset('assets/images/level.png', height: 15)
        ],
        if (evszak.contains('termes')) ...[
          Image.asset('assets/images/termes.png', height: 15)
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _alCim('Díszítőérték'),
        Row(children: [
          Expanded(
              child: Column(
            children: [
              Row(
                children: [
                  const Text('Tavasz:',
                      style: TextStyle(
                        fontSize: 13,
                      )),
                  showLista(diszitoertek['tavasz'])
                ],
              ),
              Row(
                children: [
                  const Text('Nyár:',
                      style: TextStyle(
                        fontSize: 13,
                      )),
                  showLista(diszitoertek['nyar'])
                ],
              )
            ],
          )),
          Expanded(
              child: Column(
            children: [
              Row(
                children: [
                  const Text('Ősz:',
                      style: TextStyle(
                        fontSize: 13,
                      )),
                  showLista(diszitoertek['osz'])
                ],
              ),
              Row(
                children: [
                  const Text('Tél:',
                      style: TextStyle(
                        fontSize: 13,
                      )),
                  showLista(diszitoertek['tel'])
                ],
              ),
            ],
          )),
        ]),
      ],
    );
  }
}

class Alkalmazas extends StatelessWidget {
  const Alkalmazas({required this.alkalmazas, super.key});

  final List<dynamic> alkalmazas;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _alCim('Alkalmazási lehetőségek'),
        Row(
          children: [
            const Text('|| '),
            for (String a in alkalmazas) ...[Text(a + ' || ')]
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
    bool vanJegyzet = appState.jegyzetek.isNotEmpty &&
        appState.jegyzetek.any((j) => j.noveny == widget.novenyId);
    if (!vanJegyzet) {
      if (_noteState == NoteState.show) {
        return ElevatedButton(
            onPressed: () {
              setState(() {
                _noteState = NoteState.write;
              });
              _controller = TextEditingController();
            },
            child: const Text('Jegyzet írása'));
      } else if (_noteState == NoteState.write) {
        return Column(
          children: [
            TextFormField(
                minLines: 5,
                maxLines: 15,
                autofocus: true,
                controller: _controller),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _noteState = NoteState.show;
                  });
                },
                child: const Text('Mégsem')),
            ElevatedButton(
                onPressed: () {
                  appState.saveNote(widget.novenyId, _controller.value.text);
                  _controller.clear();
                  setState(() {
                    _noteState = NoteState.show;
                  });
                },
                child: const Text('Mentés'))
          ],
        );
      }
    }

    JegyzetAdat? jegyzet =
        appState.jegyzetek.firstWhere((j) => j.noveny == widget.novenyId);

    if (_noteState == NoteState.modify) {
      return Column(
        children: [
          TextFormField(minLines: 5, maxLines: 15, controller: _controller),
          ElevatedButton(
              onPressed: () {
                appState.modifyNote(jegyzet.id, _controller.value.text);
                setState(() {
                  _noteState = NoteState.show;
                });
                _controller.clear();
              },
              child: const Text('Mentés'))
        ],
      );
    }

    return Column(
      children: [
        const Text(
          'Saját feljegyzések',
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
                    'Módosítva:',
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    '${jegyzet.modositva.year}.${jegyzet.modositva.month}.${jegyzet.modositva.day}. ${jegyzet.modositva.hour}:${jegyzet.modositva.minute}',
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
                    child: const Text('Törlés'))),
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _noteState = NoteState.modify;
                        _controller =
                            TextEditingController(text: jegyzet.szoveg);
                      });
                    },
                    child: const Text('Szerkesztés')))
          ],
        )
      ],
    );
  }
}
