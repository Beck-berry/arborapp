import 'package:arborapp/src/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'applicationState.dart';

class AddPlant extends StatefulWidget {
  const AddPlant({Key? key}) : super(key: key);

  @override
  _AddPlantState createState() => _AddPlantState();
}

class _AddPlantState extends State<AddPlant> {
  final _formKey = GlobalKey<FormState>();

  String nev = '';
  NovenyTipus tipus = NovenyTipus.values.first;
  String leiras = '';
  String ido = '';
  String szelesseg = '';
  String magassag = '';
  late double lat;
  late double lon;
  Map<AlkalmazasLehetoseg, bool?> alkalmazas = <AlkalmazasLehetoseg, bool?>{
    AlkalmazasLehetoseg.bokorfa: false,
    AlkalmazasLehetoseg.sorfa: false,
    AlkalmazasLehetoseg.parkfa: false
  };
  Map<Diszitoertek, bool?> diszitoTavasz = <Diszitoertek, bool?>{
    Diszitoertek.virag: false,
    Diszitoertek.lomb: false,
    Diszitoertek.kereg: false,
    Diszitoertek.level: false,
    Diszitoertek.termes: false
  };
  Map<Diszitoertek, bool?> diszitoNyar = <Diszitoertek, bool?>{
    Diszitoertek.virag: false,
    Diszitoertek.lomb: false,
    Diszitoertek.kereg: false,
    Diszitoertek.level: false,
    Diszitoertek.termes: false
  };
  Map<Diszitoertek, bool?> diszitoOsz = <Diszitoertek, bool?>{
    Diszitoertek.virag: false,
    Diszitoertek.lomb: false,
    Diszitoertek.kereg: false,
    Diszitoertek.level: false,
    Diszitoertek.termes: false
  };
  Map<Diszitoertek, bool?> diszitoTel = <Diszitoertek, bool?>{
    Diszitoertek.virag: false,
    Diszitoertek.lomb: false,
    Diszitoertek.kereg: false,
    Diszitoertek.level: false,
    Diszitoertek.termes: false
  };

  Widget _szovegesMezo(String label, String mezo) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
          ),
          onChanged: (value) => {
            setState(() {
              mezo = value;
            })
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'A mező kitöltése kötelező!';
            }
            return null;
          },
        ));
  }

  Widget _checkboxMezok(MapEntry entry, Map map, String? label) {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          value: entry.value,
          onChanged: (bool? isChecked) {
            setState(() {
              map.update(entry.key, (value) => isChecked);
            });
          },
        ),
        if (label != null) ...[Text(label)]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Növény hozzáadása',
          ),
        ),
        body: ListView(children: [
          Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _szovegesMezo('Latin név', nev),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            const Text("Típus: "),
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
                    _szovegesMezo('Leírás', leiras),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Koordináták:"),
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
                    _szovegesMezo('Élettartam', ido),
                    _szovegesMezo('Szélesség', szelesseg),
                    _szovegesMezo('Magasság', magassag),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const Text("Alkalmazási lehetőségek"),
                            for (MapEntry<AlkalmazasLehetoseg, bool?> a
                                in alkalmazas.entries) ...[
                              _checkboxMezok(a, alkalmazas, a.key.name)
                            ],
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            Text("Díszítőértékek"),
                            Table(
                              children: [
                                TableRow(children: [
                                  TableCell(child: const Text("")),
                                  for (Diszitoertek e
                                      in Diszitoertek.values) ...[
                                    TableCell(child: Text(e.name))
                                  ],
                                ]),
                                TableRow(children: [
                                  TableCell(child: const Text("Tavasz")),
                                  for (MapEntry<Diszitoertek, bool?> a
                                      in diszitoTavasz.entries) ...[
                                    TableCell(
                                        child: _checkboxMezok(
                                            a, diszitoTavasz, null))
                                  ],
                                ]),
                                TableRow(children: [
                                  TableCell(child: const Text("Nyár")),
                                  for (MapEntry<Diszitoertek, bool?> a
                                      in diszitoNyar.entries) ...[
                                    TableCell(
                                        child: _checkboxMezok(
                                            a, diszitoNyar, null))
                                  ],
                                ]),
                                TableRow(children: [
                                  TableCell(child: const Text("Ősz")),
                                  for (MapEntry<Diszitoertek, bool?> a
                                      in diszitoOsz.entries) ...[
                                    TableCell(
                                        child:
                                            _checkboxMezok(a, diszitoOsz, null))
                                  ],
                                ]),
                                TableRow(children: [
                                  TableCell(child: const Text("Tél")),
                                  for (MapEntry<Diszitoertek, bool?> a
                                      in diszitoTel.entries) ...[
                                    TableCell(
                                        child:
                                            _checkboxMezok(a, diszitoTel, null))
                                  ],
                                ])
                              ],
                            ),
                          ],
                        )),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text("Környezeti igények checkbox")),
                    Container(
                        child: ElevatedButton(
                      child: const Text('Hozzáadás'),
                      onPressed: () {
                        // It returns true if the form is valid, otherwise returns false
                        bool valid = false;
                        valid = _formKey.currentState!.validate();
                        if (valid) {
                          savePlant(appState);
                        }
                      },
                    )),
                  ]))
        ]));
  }

  void savePlant(ApplicationState appState) {
    GeoPoint koords = GeoPoint(lat, lon);
    Map<String, String> meretek = <String, String>{
      'ido': ido,
      'magassag': magassag,
      'szelesseg': szelesseg
    };
  }
}
