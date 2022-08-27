import 'package:arborapp/src/plant.dart';
import 'package:arborapp/src/types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import 'applicationState.dart';

class Search extends StatelessWidget {
  const Search({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
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
              suggestions: novenyek.map((e) => SearchFieldListItem(e.nev, child: Text(e.nev))).toList(),
              searchStyle: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(0.8),
              ),
              hint: 'Növény keresése',
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
          Text("Keresés ${appState.novenyekSzama} növény között..."),
          Expanded(
            child:ListView.builder(
              shrinkWrap: true,
              itemCount: novenyek.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(novenyek[index].nev),
                  onTap: () {
                    Noveny kivalasztottNoveny = novenyek
                      .where((noveny) => noveny.nev == novenyek[index].nev)
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