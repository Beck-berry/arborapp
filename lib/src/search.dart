import 'package:arborapp/src/plant.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class Search extends StatelessWidget {
  const Search({
    required this.novenyek,
    required this.novenyekSzama,
    super.key
  });

  final List<NovenyAdat> novenyek;
  final int novenyekSzama;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
        'Keresés',
        ),
      ),
      body: Column(
        children: [
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
                NovenyAdat kivalasztottNoveny = novenyek.where((noveny) => noveny.nev == value).first;
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Plant(noveny: kivalasztottNoveny))
                );
              },
            ),
          ),
          Text("Keresés $novenyekSzama növény között..."),
          Expanded(
            child:ListView.builder(
              shrinkWrap: true,
              itemCount: novenyek.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(novenyek[index].nev),
                  onTap: () {
                    NovenyAdat kivalasztottNoveny = novenyek.where((noveny) => noveny.nev == novenyek[index].nev).first;
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Plant(noveny: kivalasztottNoveny))
                    );
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