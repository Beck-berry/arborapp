import 'dart:ui';

enum LoginState {
  loggedOut,
  login,
  register,
  loggedIn,
}

enum NoteState { show, write, modify }

enum AlkalmazasLehetoseg { parkfa, bokorfa, sorfa }

extension AlkalmazasLehetosegExt on AlkalmazasLehetoseg {
  String get name {
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

enum Diszitoertek { lomb, virag, termes, level, kereg }

extension DiszitoertekExt on Diszitoertek {
  String get name {
    switch (this) {
      case Diszitoertek.termes:
        return "termés";
      case Diszitoertek.lomb:
        return "lomb";
      case Diszitoertek.virag:
        return "virág";
      case Diszitoertek.level:
        return "levél";
      case Diszitoertek.kereg:
        return "kéreg";
    }
  }
}

enum NovenyTipus { fenyo, lombosFa, cserje }

extension NovenyTipusExt on NovenyTipus {
  String get name {
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
        return const Color(0xFF008000);
      case NovenyTipus.lombosFa:
        return const Color(0xFF32CD32);
      case NovenyTipus.cserje:
        return const Color(0xFFDC143C);
    }
  }
}