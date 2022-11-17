import 'dart:ui';

enum LoginState {
  loggedOut,
  login,
  register,
  loggedIn,
  changePassword,
}

enum NoteState { show, write, modify }

enum AlkalmazasLehetoseg { parkfa, bokorfa, sorfa }

extension AlkalmazasLehetosegExt on AlkalmazasLehetoseg {
  String get nev {
    switch (this) {
      case AlkalmazasLehetoseg.parkfa:
        return 'parkfa';
      case AlkalmazasLehetoseg.bokorfa:
        return 'bokorfa';
      case AlkalmazasLehetoseg.sorfa:
        return 'sorfa';
    }
  }
}

enum Diszitoertek { lomb, virag, termes, kereg }

extension DiszitoertekExt on Diszitoertek {
  String get nev {
    switch (this) {
      case Diszitoertek.termes:
        return 'termés';
      case Diszitoertek.lomb:
        return 'lomb';
      case Diszitoertek.virag:
        return 'virág';
      case Diszitoertek.kereg:
        return 'kéreg';
    }
  }
}

enum NapfenyIgeny { napos, fel, arnyek }

extension NapfenyIgenyExt on NapfenyIgeny {
  String get nev {
    switch (this) {
      case NapfenyIgeny.napos:
        return 'napos';
      case NapfenyIgeny.fel:
        return 'félárnyékos';
      case NapfenyIgeny.arnyek:
        return 'árnyékos';
    }
  }
}

enum TalajIgeny { meszes, semleges, savanyu }

extension TalajIgenyExt on TalajIgeny {
  String get nev {
    switch (this) {
      case TalajIgeny.meszes:
        return 'meszes';
      case TalajIgeny.savanyu:
        return 'savanyú';
      case TalajIgeny.semleges:
        return 'semleges';
    }
  }
}

enum NovenyTipus { fenyo, lombosFa, cserje }

extension NovenyTipusExt on NovenyTipus {
  String get nev {
    switch (this) {
      case NovenyTipus.fenyo:
        return 'tű- és pikkelylevelű';
      case NovenyTipus.lombosFa:
        return 'lombos fa';
      case NovenyTipus.cserje:
        return 'cserje';
    }
  }

  Color get szin {
    switch (this) {
      case NovenyTipus.fenyo:
        return const Color(0xFF0000FF);
      case NovenyTipus.lombosFa:
        return const Color(0xFFFF4500);
      case NovenyTipus.cserje:
        return const Color(0xFFFF00FF);
    }
  }
}