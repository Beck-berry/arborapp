import 'dart:async';

import 'package:arborapp/src/enums.dart';
import 'package:arborapp/src/types.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

import '../firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  LoginState _loginState = LoginState.loggedOut;
  LoginState get loginState => _loginState;

  late String? _currentUser;
  String? get currentUser => _currentUser;

  late DocumentReference megnyitottNoveny;

  List<NovenyAdat> _novenyek = [];
  List<NovenyAdat> get novenyek => _novenyek;

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

    initNovenyek();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = LoginState.loggedIn;
        _currentUser = user.uid;
        initJegyzetek();
      } else {
        _loginState = LoginState.loggedOut;
        _currentUser = null;
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
        _novenyek.add(
          NovenyAdat(
              id: document.reference,
              nev: document.data()['nev'] as String,
              leiras: document.data()['leiras'] as String,
              meret: document.data()['meret'],
              igenyek: document.data()['kornyezeti_igenyek'],
              diszitoertek: document.data()['diszitoertek'],
              alkalmazas: document.data()['alkalmazas'] as String,
              coords: LatLng(document.data()['lat'], document.data()['lon']),
              tipus: NovenyTipus.values.byName(document.data()['tipus'])
          ),
        );
      }
    });
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

  Future<bool> verifyEmail(String email,
      void Function(FirebaseAuthException e) errorCallback,
      ) async {
    try {
      var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
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

  Future<void> register(
      String email,
      String nickname,
      String password,
      void Function(FirebaseAuthException e) errorCallback
      ) async {
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
    _loginState = LoginState.loggedOut;
    notifyListeners();
  }

  Future<void> resetPassword(
      String email,
      void Function(FirebaseAuthException e) errorCallback
      ) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
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
}