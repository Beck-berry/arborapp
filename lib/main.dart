import 'dart:async';

import 'package:arborapp/src/enums.dart';
import 'package:arborapp/src/plant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'src/map.dart';
import 'src/search.dart';
import 'src/profile.dart';

void main() {
  runApp(const Arborapp());
}

class Arborapp extends StatelessWidget {
  const Arborapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationState(), // ← create/init your state model
      child: MaterialApp(
        title: 'Arborapp',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const MyHomePage(cim: 'Arborapp'),
      )
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.cim}) : super(key: key);

  final String cim;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(cim),
        ),
        body: Column(
          children: [
            const Icon(
              Icons.forest,
              size: 100,
              color: Colors.green,
            ),
             Container(
               margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
               child:
                 const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla elementum tempor dolor id varius. Nulla dictum ipsum sit amet elit tincidunt, at iaculis ex condimentum. In hac habitasse platea dictumst. Cras vitae metus aliquet eros ornare egestas id non ipsum. Maecenas lobortis pretium libero, vel scelerisque erat eleifend nec. Nullam rhoncus nisi id justo vehicula efficitur. Quisque erat sapien, maximus a metus non, ullamcorper tincidunt nibh.',
                    textAlign: TextAlign.justify,
                )
             ),
            const FoMenuButton(
              cimke: "Barangolás a térképen",
              ikon: Icons.map,
              onPress: Map(),
            ),
            FoMenuButton(
              cimke: "Növény keresése",
              ikon: Icons.search,
              onPress: Consumer<ApplicationState>(
                builder: (context, appState, _) => Search(
                    novenyek: appState.novenyek,
                    novenyekSzama: appState.novenyekSzama
                ),
              ),
            ),
            FoMenuButton(
              cimke: "Saját jegyzeteim",
              ikon: Icons.edit,
              onPress: Consumer<ApplicationState>(
                builder: (context, appState, _) => Search(
                    novenyek: appState.novenyek,
                    novenyekSzama: appState.novenyekSzama
                ),
              ),
            ),
            FoMenuButton(
              cimke: "Profil beállítások",
              ikon: Icons.face,
              onPress: Consumer<ApplicationState>(
                builder: (context, appState, _) => Profile(
                  loginState: appState.loginState,
                  startLogin: appState.startLogin,
                  startRegister: appState.startRegister,
                  verifyEmail: appState.verifyEmail,
                  signIn: appState.signIn,
                  megszakit: appState.megszakit,
                  register: appState.register,
                  signOut: appState.signOut,
                  resetPassword: appState.resetPassword
                )
              ),
            ),
          ]
        )
    );
  }
}

class FoMenuButton extends StatelessWidget {
  const FoMenuButton({Key? key, required this.cimke, required this.ikon, required this.onPress}) : super(key: key);

  final String cimke;
  final IconData ikon;
  final Widget onPress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
        ElevatedButton.icon(
          label: Text(cimke),
          icon: Icon(ikon, size: 20),
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(300, 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => onPress)
            );
          }
        ),
    );
  }
}

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