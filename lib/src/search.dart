import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
        'Keresés',
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: SearchField(
          suggestions: ['ABC', 'DEF', 'GHI', 'JKL'].map((e) => SearchFieldListItem(e, child: Text(e))).toList(),
          searchStyle: TextStyle(
            fontSize: 18,
            color: Colors.black.withOpacity(0.8),
          ),
          hint: 'Növény neve',
          hasOverlay: false,
        ),
      )
    );
  }
}