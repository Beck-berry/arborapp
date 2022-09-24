import 'package:arborapp/src/plant.dart';
import 'package:arborapp/src/types.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import 'applicationState.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    List<Noveny> novenyek = appState.novenyek;
    SuspensionUtil.sortListBySuspensionTag(novenyek);

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
              controller: _searchController,
              suggestions: novenyek
                  .map((e) => SearchFieldListItem(e.nev, child: Text(e.nev)))
                  .toList(),
              searchStyle: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(0.8),
              ),
              hint: 'Növény keresése',
              hasOverlay: false,
              onSuggestionTap: (value) {
                Noveny kivalasztottNoveny = novenyek
                    .where((noveny) => noveny.nev == value.searchKey)
                    .first;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Plant(noveny: kivalasztottNoveny)));
              },
              suggestionAction: SuggestionAction.unfocus,
              suggestionState: Suggestion.hidden,
            ),
          ),
          Expanded(
            child: AzListView(
            data: novenyek,
            itemCount: novenyek.length,
            itemBuilder: (context, index) {
              final noveny = novenyek[index];
              return ListTile(
                title: Text(noveny.nev),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Plant(
                              noveny: appState.getNovenyById(noveny.id))));
                },
              );
            },
            indexBarMargin: const EdgeInsets.all(5.0),
            indexBarOptions: const IndexBarOptions(
                needRebuild: true,
                indexHintAlignment: Alignment.centerRight,
                indexHintDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(6.0))),
                selectItemDecoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                selectTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                )),
          ))
        ]));
  }
}
