import 'dart:async';

import 'package:arborapp/src/enums.dart';
import 'package:arborapp/src/plant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  LoginState _loginState = LoginState.loggedOut;
  LoginState get loginState => _loginState;

  List<NovenyAdat> _novenyek = [];
  List<NovenyAdat> get novenyek => _novenyek;

  int _novenyekSzama = 0;
  int get novenyekSzama => _novenyekSzama;

  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseFirestore.instance
        .collection('novenyek')
        .orderBy('nev', descending: true)
    //.limit(50)
        .snapshots()
        .listen((snapshot) {
      _novenyek = [];
      _novenyekSzama = snapshot.docs.length;
      for (final document in snapshot.docs) {
        _novenyek.add(
          NovenyAdat(
              nev: document.data()['nev'] as String,
              leiras: document.data()['leiras'] as String,
              meret: document.data()['meret'],
              igenyek: document.data()['kornyezeti_igenyek'],
              diszitoertek: document.data()['diszitoertek'],
              alkalmazas: document.data()['alkalmazas'] as String
          ),
        );
      }
    });

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = LoginState.loggedIn;
      } else {
        _loginState = LoginState.loggedOut;
      }
      notifyListeners();
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
}