import 'package:arborapp/src/plant.dart';
import 'package:arborapp/src/types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import 'applicationState.dart';

class Notes extends StatelessWidget {
  const Notes({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    List<JegyzetAdat> jegyzetek = appState.jegyzetek;
    List<Noveny> novenyek = appState.novenyek;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Keresés',
          ),
        ),
        body: Column(children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: SearchField(
                  suggestions: jegyzetek.map((j) => SearchFieldListItem(
                      novenyek.where((n) => n.id == j.noveny).first.nev,
                      child: Text(novenyek.where((n) => n.id == j.noveny).first.nev))
                  ).toList(),
                  searchStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  hint: 'Jegyzet keresése',
                  hasOverlay: false,
                  onSubmit: (value) {
                    Noveny kivalasztottNoveny =
                    novenyek.where((noveny) => noveny.nev == value).first;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Plant(noveny: kivalasztottNoveny)));
              },
                ),
              ),
              Text("Keresés ${appState.jegyzetekSzama} jegyzet között..."),
              Expanded(
                  child:ListView.builder(
                    shrinkWrap: true,
                    itemCount: jegyzetek.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(novenyek.where((n) => n.id == jegyzetek[index].noveny).first.nev),
                        subtitle: Text("Módosítva: ${jegyzetek[index].modositva.year}.${jegyzetek[index].modositva.month}.${jegyzetek[index].modositva.day}. ${jegyzetek[index].modositva.hour}:${jegyzetek[index].modositva.minute}"),
                        onTap: () {
                          Noveny kivalasztottNoveny = novenyek
                      .where((noveny) => noveny.id == jegyzetek[index].noveny)
                      .first;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Plant(noveny: kivalasztottNoveny)));
                },
                      );
                    },
                  )
              )
            ]
        )
    );
  }
}
