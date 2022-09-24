import 'package:arborapp/src/addPlant.dart';
import 'package:arborapp/src/types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import 'applicationState.dart';

class EditPlant extends StatefulWidget {
  const EditPlant({Key? key}) : super(key: key);

  @override
  EditPlantState createState() => EditPlantState();
}

class EditPlantState extends State<EditPlant> {
  bool novenyKivalasztva = false;
  late Noveny valasztottNoveny;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    List<Noveny> novenyek = appState.novenyek;

    if (!novenyKivalasztva) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Növény szerkesztése',
            ),
          ),
          body: Column(children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: SearchField(
                suggestions: novenyek
                    .map((e) => SearchFieldListItem(e.nev, child: Text(e.nev)))
                    .toList(),
                searchStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.8),
                ),
                hint: 'Növény választása',
                hasOverlay: false,
                onSuggestionTap: (value) {
                  setState(() {
                    novenyKivalasztva = true;
                    valasztottNoveny = novenyek
                        .where((noveny) => noveny.nev == value.searchKey)
                        .first;
                  });
                },
                suggestionAction: SuggestionAction.unfocus,
                suggestionState: Suggestion.hidden,
              ),
            ),
          ]));
    }

    return AddPlant(noveny: valasztottNoveny);
  }
}
