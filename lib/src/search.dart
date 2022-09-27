import 'package:arborapp/src/plant.dart';
import 'package:arborapp/src/types.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import 'applicationState.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> scanQR(ApplicationState appState) async {
    Noveny? novenyRes;
    try {
      String novenyId = await FlutterBarcodeScanner.scanBarcode(
          '#00FF00', 'Mégsem', true, ScanMode.QR);
      novenyRes = appState.getNovenyByIdString(novenyId);
    } on PlatformException {
      novenyRes = null;
    }

    if (!mounted) return;

    if (novenyRes != null) {
      megnyitasPopup(novenyRes);
    } else {
      errorPopup();
    }
  }

  void errorPopup() {
    showDialog<void>(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text(
              'Hiba a QR kód beolvasása közben',
              style: TextStyle(fontSize: 18),
            ),
            content: Text(
              'Próbáld újra',
              style: TextStyle(fontSize: 13),
            ),
          );
        });
  }

  void megnyitasPopup(Noveny noveny) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            noveny.nev,
            style: const TextStyle(fontSize: 18),
          ),
          content: Text(
            noveny.tipus.name,
            style: const TextStyle(fontSize: 13),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Mégsem'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // close popup
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Plant(noveny: noveny)));
              },
              child: const Text('Megnyitás'),
            ),
          ],
        );
      },
    );
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
          actions: [
            IconButton(
                onPressed: () {
                  scanQR(appState);
                },
                icon: const Icon(Icons.qr_code_scanner))
          ],
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
