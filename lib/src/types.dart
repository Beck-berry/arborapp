import 'package:arborapp/src/enums.dart';
import 'package:azlistview/azlistview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Noveny extends ISuspensionBean {
  Noveny({required this.id, required this.nev, required this.tipus});

  final DocumentReference id;
  final String nev;
  final NovenyTipus tipus;

  @override
  String getSuspensionTag() => nev.substring(0);
}

class NovenyAdat {
  NovenyAdat(
      {required this.id,
      required this.novenyId,
      required this.leiras,
      required this.meret,
      required this.igenyek,
      required this.diszitoertek,
      required this.alkalmazas});

  final DocumentReference id;
  final DocumentReference novenyId;
  final String leiras;
  final Map<String, dynamic> meret;
  final Map<String, dynamic> igenyek;
  final Map<String, dynamic> diszitoertek;
  final List<dynamic> alkalmazas;
}

class NovenyKoordinata {
  NovenyKoordinata(
      {required this.id, required this.novenyId, required this.coords});

  final DocumentReference id;
  final DocumentReference novenyId;
  final GeoPoint coords;
}

class JegyzetAdat {
  JegyzetAdat(
      {required this.id,
      required this.noveny,
      required this.modositva,
      required this.szoveg,
      required this.szerzo});

  final DocumentReference id;
  final DocumentReference noveny;
  final DateTime modositva;
  final String szoveg;
  final String szerzo;
}