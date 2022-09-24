import 'dart:async';

import 'package:arborapp/src/enums.dart';
import 'package:arborapp/src/types.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  late String appName;
  late String packageName;
  late String version;
  late String buildNumber;

  LoginState _loginState = LoginState.loggedOut;

  LoginState get loginState => _loginState;

  late String? _currentUser;

  String? get currentUser => _currentUser;

  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  List<Noveny> _novenyek = [];

  List<Noveny> get novenyek => _novenyek;

  int _novenyekSzama = 0;

  int get novenyekSzama => _novenyekSzama;

  List<JegyzetAdat> _jegyzetek = [];

  List<JegyzetAdat> get jegyzetek => _jegyzetek;

  int _jegyzetekSzama = 0;

  int get jegyzetekSzama => _jegyzetekSzama;

  NoteState _noteState = NoteState.show;

  NoteState get noteState => _noteState;

  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;

    initNovenyek();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = LoginState.loggedIn;
        _currentUser = user.uid;
        FirebaseFirestore.instance
            .collection('admin')
            .snapshots()
            .listen((snapshot) {
          for (final document in snapshot.docs) {
            _isAdmin = document.data()['userId'] == _currentUser;
            if (_isAdmin) {
              break;
            }
          }
        });
        initJegyzetek();
      } else {
        _loginState = LoginState.loggedOut;
        _currentUser = null;
        _isAdmin = false;
      }
      notifyListeners();
    });
  }

  void initNovenyek() {
    FirebaseFirestore.instance
        .collection('novenyek')
        .orderBy('nev', descending: true)
        .snapshots()
        .listen((snapshot) {
      _novenyek = [];
      _novenyekSzama = snapshot.docs.length;
      for (final document in snapshot.docs) {
        _novenyek.add(Noveny(
            id: document.reference,
            nev: document.data()['nev'] as String,
            tipus: NovenyTipus.values.byName(document.data()['tipus'])));
      }
    });
  }

  Noveny getNovenyById(DocumentReference novenyId) {
    return novenyek.where((n) => n.id == novenyId).single;
  }

  void initJegyzetek() {
    FirebaseFirestore.instance
        .collection('jegyzetek')
        .orderBy('modositva', descending: true)
        .where('user', isEqualTo: _currentUser)
        .snapshots()
        .listen((snapshot) {
      _jegyzetek = [];
      _jegyzetekSzama = snapshot.docs.length;
      for (final document in snapshot.docs) {
        _jegyzetek.add(
          JegyzetAdat(
              id: document.reference,
              noveny: document.data()['noveny'],
              modositva: DateTime.fromMillisecondsSinceEpoch(document.data()['modositva']),
              szoveg: document.data()['szoveg'] as String,
              szerzo: document.data()['user']
          ),
        );
      }
    });
  }

  void startLogin() {
    _loginState = LoginState.login;
    notifyListeners();
  }

  void startRegister() {
    _loginState = LoginState.register;
    notifyListeners();
  }

  void megszakit() {
    _loginState = LoginState.loggedOut;
    notifyListeners();
  }

  Future<bool> verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return methods.contains('password');
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
      return false;
    }
  }

  Future<void> signIn(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> register(String email, String nickname, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(nickname);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    _currentUser = null;
    _loginState = LoginState.loggedOut;
    notifyListeners();
  }

  Future<void> resetPassword(String email,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> deleteAcc(
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      FirebaseAuth.instance.currentUser?.delete();
      for (var j in _jegyzetek) {
        FirebaseFirestore.instance
            .collection('jegyzetek')
            .doc(j.id.id)
            .delete();
      }
      _loginState = LoginState.loggedOut;
      _currentUser = null;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<NovenyAdat> getNovenyAdat(DocumentReference novenyId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('novenyAdat')
        .where('noveny_id', isEqualTo: novenyId)
        .limit(1)
        .get();

    var document = snapshot.docs[0];
    return NovenyAdat(
        id: document.reference,
        novenyId: document.data()['noveny_id'] as DocumentReference,
        leiras: document.data()['leiras'] as String,
        meret: document.data()['meret'],
        igenyek: document.data()['kornyezeti_igeny'],
        diszitoertek: document.data()['diszitoertek'],
        alkalmazas: document.data()['alkalmazas']);
  }

  Future<List<NovenyKoordinata>> initKoordinatak() async {
    List<NovenyKoordinata> koordinatak = [];

    FirebaseFirestore.instance
        .collection('koordinata')
        .snapshots()
        .listen((snapshot) {
      for (final document in snapshot.docs) {
        koordinatak.add(NovenyKoordinata(
            id: document.reference,
            novenyId: document.data()['noveny_id'] as DocumentReference,
            coords: document.data()['coords']));
      }
    });

    return koordinatak;
  }

  Future<List<NovenyKoordinata>> getKoordinatak(
      DocumentReference novenyId) async {
    List<NovenyKoordinata> koordinatak = [];

    FirebaseFirestore.instance
        .collection('koordinata')
        .where('noveny_id', isEqualTo: novenyId)
        .snapshots()
        .listen((snapshot) {
      for (final document in snapshot.docs) {
        koordinatak.add(NovenyKoordinata(
            id: document.reference,
            novenyId: document.data()['noveny_id'] as DocumentReference,
            coords: document.data()['coords']));
      }
    });

    return koordinatak;
  }

  Future<List<NovenyKoordinata>> loadNovenyKoordinatak(novenyId) async {
    if (novenyId == null) {
      return await initKoordinatak();
    } else {
      return await getKoordinatak(novenyId);
    }
  }

  void saveNote(DocumentReference noveny, String szoveg) async {
    if (szoveg.isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('jegyzetek')
        .add(<String, dynamic>{
      'szoveg': szoveg,
      'modositva': DateTime.now().millisecondsSinceEpoch,
      'noveny': noveny,
      'user': FirebaseAuth.instance.currentUser!.uid,
    });
    initJegyzetek();
  }

  void modifyNote(DocumentReference jegyzetId, String szoveg) async {
    if (szoveg.isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('jegyzetek')
        .doc(jegyzetId.id)
        .update(<String, dynamic>{
      'modositva': DateTime.now().millisecondsSinceEpoch,
      'szoveg': szoveg,
    });
    initJegyzetek();
  }

  void deleteNote(DocumentReference jegyzetId) async {
    await FirebaseFirestore.instance
        .collection('jegyzetek')
        .doc(jegyzetId.id)
        .delete();
    initJegyzetek();
  }

  Future<void> saveNoveny(
      DocumentReference id,
      String tipus,
      String nev,
      String leiras,
      GeoPoint koords,
      Map<String, String> meret,
      List<String> alkalmazas,
      Map<String, List<String>> diszitoertek,
      Map<String, List<String>> igenyek) async {
    await FirebaseFirestore.instance
        .collection('novenyek')
        .doc(id.id)
        .update(<String, String>{'nev': nev, 'tipus': tipus});

    await FirebaseFirestore.instance
        .collection('novenyAdat')
        .where('noveny_id', isEqualTo: id.id)
        .limit(1)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.update(<String, dynamic>{
          'leiras': leiras,
          'meret': meret,
          'alkalmazas': alkalmazas,
          'diszitoertek': diszitoertek,
          'kornyezeti_igeny': igenyek
        });
      }
    });

    await FirebaseFirestore.instance
        .collection('koordinata')
        .where('noveny_id', isEqualTo: id.id)
        .limit(1)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.update(<String, dynamic>{'coords': koords});
      }
    });

    initNovenyek();
  }

  Future<void> saveNewNoveny(
      String tipus,
      String nev,
      String leiras,
      GeoPoint koords,
      Map<String, String> meret,
      List<String> alkalmazas,
      Map<String, List<String>> diszitoertek,
      Map<String, List<String>> igenyek) async {
    DocumentReference<Map<String, dynamic>> novenyId = await FirebaseFirestore
        .instance
        .collection('novenyek')
        .add(<String, String>{'nev': nev, 'tipus': tipus});

    await FirebaseFirestore.instance
        .collection('novenyAdat')
        .add(<String, dynamic>{
      'noveny_id': novenyId,
      'leiras': leiras,
      'meret': meret,
      'alkalmazas': alkalmazas,
      'diszitoertek': diszitoertek,
      'kornyezeti_igeny': igenyek
    });

    await FirebaseFirestore.instance
        .collection('koordinata')
        .add(<String, dynamic>{'noveny_id': novenyId, 'coords': koords});

    initNovenyek();
  }
}