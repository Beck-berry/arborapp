import 'package:cloud_firestore/cloud_firestore.dart';

class NovenyAdat {
  NovenyAdat({
    required this.id,
    required this.nev,
    required this.leiras,
    required this.meret,
    required this.igenyek,
    required this.diszitoertek,
    required this.alkalmazas
  });

  final DocumentReference id;
  final String nev;
  final String leiras;
  final Map<String, dynamic> meret;
  final Map<String, dynamic> igenyek;
  final Map<String, dynamic> diszitoertek;
  final String alkalmazas;
}

class JegyzetAdat {
  JegyzetAdat({
    required this.id,
    required this.noveny,
    required this.modositva,
    required this.szoveg,
    required this.szerzo
  });

  final DocumentReference id;
  final DocumentReference noveny;
  final DateTime modositva;
  final String szoveg;
  final String szerzo;
}