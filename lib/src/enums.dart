import 'dart:ui';

enum LoginState {
  loggedOut,
  login,
  register,
  loggedIn,
}

enum NoteState {
  show,
  write,
  modify
}

enum NovenyTipus {
  fenyo,
  lombosFa
}

extension NovenyTipusExt on NovenyTipus {
  String get name {
    switch (this) {
      case NovenyTipus.fenyo:
        return 'fenyő';
      case NovenyTipus.lombosFa:
        return 'lombos fa';
      default:
        return '';
    }
  }

  Color get szin {
    switch (this) {
      case NovenyTipus.fenyo:
        return const Color(0xFF008000);
      case NovenyTipus.lombosFa:
        return const Color(0xFF32CD32);
      default:
        return const Color(0xFFDC143C);
    }
  }
}