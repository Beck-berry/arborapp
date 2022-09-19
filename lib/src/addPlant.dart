import 'package:arborapp/src/enums.dart';
import 'package:arborapp/src/load.dart';
import 'package:arborapp/src/types.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'applicationState.dart';
import 'error.dart';

class AddPlant extends StatelessWidget {
  const AddPlant({this.noveny, Key? key}) : super(key: key);

  final Noveny? noveny;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);

    if (noveny != null) {
      return FutureBuilder<NovenyAdat>(
          future: appState.getNovenyAdat(noveny!.id),
          builder: (BuildContext context,
              AsyncSnapshot<NovenyAdat> novenyAdatSnapshot) {
            switch (novenyAdatSnapshot.connectionState) {
              case ConnectionState.waiting:
                return const LoadingScreen(cim: 'Növény szerkesztése');
              default:
                if (novenyAdatSnapshot.hasError) {
                  return ErrorScreen(hiba: novenyAdatSnapshot.error);
                } else {
                  return _AddPlantForm(
                      noveny: noveny, novenyAdat: novenyAdatSnapshot.data);
                }
            }
          });
    }

    return const _AddPlantForm();
  }
}

class _AddPlantForm extends StatefulWidget {
  const _AddPlantForm({this.noveny, this.novenyAdat, Key? key})
      : super(key: key);

  final Noveny? noveny;
  final NovenyAdat? novenyAdat;

  @override
  _AddPlantFormState createState() => _AddPlantFormState();
}

class _AddPlantFormState extends State<_AddPlantForm> {
  final _formKey = GlobalKey<FormState>();

  String cim = 'Növény hozzáadása';
  late String nev;
  late NovenyTipus tipus;
  late String leiras;
  late String ido;
  late String szelesseg;
  late String magassag;
  late double lat;
  late double lon;
  Map<AlkalmazasLehetoseg, bool> alkalmazas = <AlkalmazasLehetoseg, bool>{
    AlkalmazasLehetoseg.bokorfa: false,
    AlkalmazasLehetoseg.sorfa: false,
    AlkalmazasLehetoseg.parkfa: false
  };
  Map<Diszitoertek, bool> diszitoTavasz = <Diszitoertek, bool>{
    Diszitoertek.lomb: false,
    Diszitoertek.virag: false,
    Diszitoertek.termes: false,
    Diszitoertek.level: false,
    Diszitoertek.kereg: false
  };
  Map<Diszitoertek, bool> diszitoNyar = <Diszitoertek, bool>{
    Diszitoertek.lomb: false,
    Diszitoertek.virag: false,
    Diszitoertek.termes: false,
    Diszitoertek.level: false,
    Diszitoertek.kereg: false
  };
  Map<Diszitoertek, bool> diszitoOsz = <Diszitoertek, bool>{
    Diszitoertek.lomb: false,
    Diszitoertek.virag: false,
    Diszitoertek.termes: false,
    Diszitoertek.level: false,
    Diszitoertek.kereg: false
  };
  Map<Diszitoertek, bool> diszitoTel = <Diszitoertek, bool>{
    Diszitoertek.lomb: false,
    Diszitoertek.virag: false,
    Diszitoertek.termes: false,
    Diszitoertek.level: false,
    Diszitoertek.kereg: false
  };
  Map<NapfenyIgeny, bool> napfenyIgeny = <NapfenyIgeny, bool>{
    NapfenyIgeny.napos: false,
    NapfenyIgeny.fel: false,
    NapfenyIgeny.arnyek: false
  };
  Map<TalajIgeny, bool> talajIgeny = <TalajIgeny, bool>{
    TalajIgeny.semleges: false,
    TalajIgeny.meszes: false,
    TalajIgeny.savanyu: false
  };

  @override
  void initState() {
    if (widget.noveny != null && widget.novenyAdat != null) {
      cim = 'Növény szerkesztése';
      initNovenyAdatok();
    } else {
      nev = '';
      tipus = NovenyTipus.values.first;
      leiras = '';
      ido = '';
      szelesseg = '';
      magassag = '';
    }
    super.initState();
  }

  void initNovenyAdatok() {
    nev = widget.noveny!.nev;
    leiras = widget.novenyAdat!.leiras;
    tipus = widget.noveny!.tipus;

    Map<String, dynamic> meretek = widget.novenyAdat!.meret;
    ido = meretek['ido'];
    magassag = meretek['magassag'];
    szelesseg = meretek['szelesseg'];

    Map<String, dynamic> igenyek = widget.novenyAdat!.igenyek;
    napfenyIgeny[NapfenyIgeny.napos] = igenyek['fenyigeny'].contains('napos');
    napfenyIgeny[NapfenyIgeny.fel] =
        igenyek['fenyigeny'].contains('felarnyekos');
    napfenyIgeny[NapfenyIgeny.arnyek] =
        igenyek['fenyigeny'].contains('arnyekos');

    Map<String, dynamic> diszitoertek = widget.novenyAdat!.diszitoertek;
    diszitoTavasz[Diszitoertek.kereg] =
        diszitoertek['tavasz'].contains('kereg');
    diszitoTavasz[Diszitoertek.lomb] = diszitoertek['tavasz'].contains('lomb');
    diszitoTavasz[Diszitoertek.level] =
        diszitoertek['tavasz'].contains('level');
    diszitoTavasz[Diszitoertek.virag] =
        diszitoertek['tavasz'].contains('virag');
    diszitoTavasz[Diszitoertek.termes] =
        diszitoertek['tavasz'].contains('termes');
    diszitoNyar[Diszitoertek.kereg] = diszitoertek['nyar'].contains('kereg');
    diszitoNyar[Diszitoertek.lomb] = diszitoertek['nyar'].contains('lomb');
    diszitoNyar[Diszitoertek.level] = diszitoertek['nyar'].contains('level');
    diszitoNyar[Diszitoertek.virag] = diszitoertek['nyar'].contains('virag');
    diszitoNyar[Diszitoertek.termes] = diszitoertek['nyar'].contains('termes');
    diszitoOsz[Diszitoertek.kereg] = diszitoertek['osz'].contains('kereg');
    diszitoOsz[Diszitoertek.lomb] = diszitoertek['osz'].contains('lomb');
    diszitoOsz[Diszitoertek.level] = diszitoertek['osz'].contains('level');
    diszitoOsz[Diszitoertek.virag] = diszitoertek['osz'].contains('virag');
    diszitoOsz[Diszitoertek.termes] = diszitoertek['osz'].contains('termes');
    diszitoTel[Diszitoertek.kereg] = diszitoertek['tel'].contains('kereg');
    diszitoTel[Diszitoertek.lomb] = diszitoertek['tel'].contains('lomb');
    diszitoTel[Diszitoertek.level] = diszitoertek['tel'].contains('level');
    diszitoTel[Diszitoertek.virag] = diszitoertek['tel'].contains('virag');
    diszitoTel[Diszitoertek.termes] = diszitoertek['tel'].contains('termes');

    List<dynamic> alkalmazasiLehetoseg = widget.novenyAdat!.alkalmazas;
    alkalmazas[AlkalmazasLehetoseg.bokorfa] =
        alkalmazasiLehetoseg.contains('bokorfa');
    alkalmazas[AlkalmazasLehetoseg.sorfa] =
        alkalmazasiLehetoseg.contains('sorfa');
    alkalmazas[AlkalmazasLehetoseg.parkfa] =
        alkalmazasiLehetoseg.contains('parkfa');
  }

  Widget _szovegesMezo(String label, bool csakSzam, Object initialValue,
      Function(String) onChanged) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          initialValue: initialValue.toString(),
          decoration: InputDecoration(
            labelText: label,
          ),
          keyboardType: csakSzam ? TextInputType.number : TextInputType.text,
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'A mező kitöltése kötelező!';
            }
            return null;
          },
        ));
  }

  Widget _checkboxMezo(MapEntry entry, Map map, String? label) {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          value: entry.value,
          onChanged: (bool? isChecked) {
            setState(() {
              map.update(entry.key, (value) => isChecked!);
            });
          },
        ),
        if (label != null) ...[Text(label)]
      ],
    );
  }

  Widget kisCim(String cim) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.center,
      color: Colors.green,
      child:
          Text(cim, style: const TextStyle(color: Colors.white, fontSize: 15)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(cim),
        ),
        body: ListView(children: [
          Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: kisCim('Alapadatok')),
                    _szovegesMezo(
                        'Latin név',
                        false,
                        nev,
                        (value) => {
                              setState(() {
                                nev = value;
                              })
                            }),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Text('Típus:'),
                            const Padding(padding: EdgeInsets.all(10.0)),
                            DropdownButton(
                              value: tipus,
                              items: NovenyTipus.values
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e.name)))
                                  .toList(),
                              onChanged: (value) => {
                                setState(() {
                                  tipus = value as NovenyTipus;
                                })
                              },
                            )
                          ],
                        )),
                    _szovegesMezo(
                        'Leírás',
                        false,
                        leiras,
                        (value) => {
                              setState(() {
                                leiras = value;
                              })
                            }),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(children: [
                          const Text('Koordináták:'),
                          const Padding(padding: EdgeInsets.all(10.0)),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'lat',
                                constraints: BoxConstraints(maxWidth: 100)),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => {
                              setState(() {
                                lat = double.parse(value);
                              })
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'A mező kitöltése kötelező!';
                              }
                              return null;
                            },
                          ),
                          const Padding(padding: EdgeInsets.all(10.0)),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'lon',
                                constraints: BoxConstraints(maxWidth: 100)),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => {
                              setState(() {
                                lon = double.parse(value);
                              })
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'A mező kitöltése kötelező!';
                              }
                              return null;
                            },
                          )
                        ])),
                    _szovegesMezo(
                        'Élettartam',
                        true,
                        ido,
                        (value) => {
                              setState(() {
                                ido = value;
                              })
                            }),
                    _szovegesMezo(
                        'Szélesség',
                        true,
                        szelesseg,
                        (value) => {
                              setState(() {
                                szelesseg = value;
                              })
                            }),
                    _szovegesMezo(
                        'Magasság',
                        true,
                        magassag,
                        (value) => {
                              setState(() {
                                magassag = value;
                              })
                            }),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            kisCim('Alkalmazási lehetőségek'),
                            for (MapEntry<AlkalmazasLehetoseg, bool> a
                                in alkalmazas.entries) ...[
                              _checkboxMezo(a, alkalmazas, a.key.name)
                            ],
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            kisCim('Díszítőértékek'),
                            Table(
                              children: [
                                TableRow(children: [
                                  const TableCell(child: Text('')),
                                  for (Diszitoertek e
                                      in Diszitoertek.values) ...[
                                    TableCell(child: Text(e.name))
                                  ],
                                ]),
                                TableRow(children: [
                                  const TableCell(child: Text('Tavasz')),
                                  for (MapEntry<Diszitoertek, bool> a
                                      in diszitoTavasz.entries) ...[
                                    TableCell(
                                        child: _checkboxMezo(
                                            a, diszitoTavasz, null))
                                  ],
                                ]),
                                TableRow(children: [
                                  const TableCell(child: Text('Nyár')),
                                  for (MapEntry<Diszitoertek, bool> a
                                      in diszitoNyar.entries) ...[
                                    TableCell(
                                        child:
                                            _checkboxMezo(a, diszitoNyar, null))
                                  ],
                                ]),
                                TableRow(children: [
                                  const TableCell(child: Text('Ősz')),
                                  for (MapEntry<Diszitoertek, bool> a
                                      in diszitoOsz.entries) ...[
                                    TableCell(
                                        child:
                                            _checkboxMezo(a, diszitoOsz, null))
                                  ],
                                ]),
                                TableRow(children: [
                                  const TableCell(child: Text('Tél')),
                                  for (MapEntry<Diszitoertek, bool> a
                                      in diszitoTel.entries) ...[
                                    TableCell(
                                        child:
                                            _checkboxMezo(a, diszitoTel, null))
                                  ],
                                ])
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            kisCim('Napfényigény'),
                            for (MapEntry<NapfenyIgeny, bool> a
                                in napfenyIgeny.entries) ...[
                              _checkboxMezo(a, napfenyIgeny, a.key.name)
                            ],
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            kisCim('Talajigény'),
                            for (MapEntry<TalajIgeny, bool> a
                                in talajIgeny.entries) ...[
                              _checkboxMezo(a, talajIgeny, a.key.name)
                            ],
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              child: const Text('Mentés'),
                              onPressed: () {
                                bool valid = false;
                                valid = _formKey.currentState!.validate();
                                if (valid) {
                                  savePlant(appState, widget.noveny);
                                }
                              },
                            ),
                          ],
                        ))
                  ]))
        ]));
  }

  void savePlant(ApplicationState appState, Noveny? noveny) {
    GeoPoint koords = GeoPoint(lat, lon);
    Map<String, String> meretek = <String, String>{
      'ido': ido,
      'magassag': magassag,
      'szelesseg': szelesseg
    };

    List<String> alkalmazasok = [];
    alkalmazas.forEach((key, value) {
      if (value) {
        alkalmazasok.add(key.toString());
      }
    });

    List<String> tavasz = [];
    diszitoTavasz.forEach((key, value) {
      if (value) {
        tavasz.add(key.toString());
      }
    });

    List<String> nyar = [];
    diszitoNyar.forEach((key, value) {
      if (value) {
        nyar.add(key.toString());
      }
    });

    List<String> osz = [];
    diszitoOsz.forEach((key, value) {
      if (value) {
        osz.add(key.toString());
      }
    });

    List<String> tel = [];
    diszitoTel.forEach((key, value) {
      if (value) {
        tel.add(key.toString());
      }
    });

    Map<String, List<String>> diszitoertek = <String, List<String>>{
      'tavasz': tavasz,
      'nyar': nyar,
      'osz': osz,
      'tel': tel
    };

    List<String> napfenyIgenyList = [];
    napfenyIgeny.forEach((key, value) {
      if (value) {
        napfenyIgenyList.add(key.toString());
      }
    });

    List<String> talajList = [];
    talajIgeny.forEach((key, value) {
      if (value) {
        talajList.add(key.toString());
      }
    });

    Map<String, List<String>> igenyek = <String, List<String>>{
      'fenyigeny': napfenyIgenyList,
      'talaj': talajList
    };

    if (noveny != null) {
      appState.saveNoveny(noveny.id, tipus.name, nev, leiras, koords, meretek,
          alkalmazasok, diszitoertek, igenyek);
    } else {
      appState.saveNewNoveny(tipus.name, nev, leiras, koords, meretek,
          alkalmazasok, diszitoertek, igenyek);
    }

    /*String title = '';

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Értem',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );*/
  }
}
