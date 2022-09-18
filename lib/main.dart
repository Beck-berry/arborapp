import 'package:arborapp/src/applicationState.dart';
import 'package:arborapp/src/enums.dart';
import 'package:arborapp/src/notes.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:provider/provider.dart';

import 'src/map.dart';
import 'src/profile.dart';
import 'src/search.dart';

void main() {
  runApp(const Arborapp());
}

class Arborapp extends StatelessWidget {
  const Arborapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ApplicationState(),
        child: MaterialApp(
          title: 'Arborapp',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(appState.appName.toUpperCase()),
        ),
        body: FooterView(
            children: [
              Image.asset('assets/images/logo.png'),
              Container(
                  margin: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 20.0),
                  child: const Text(
                    'Az ARBOR APP egy digitális térképen alapuló rendszer, melynek segítségével megismerhetjük a Budai Arborétum növényállományát. Műholdképen keresztül felülnézetből láthatjuk a kert jelenlegi szerkezetét, melynek legfontosabb elemei a fásszárú taxonok. A térkép jelöli az adott növény helyzetét és tudományos nevét. Az adott növényre kattintva megismerhetjük a taxon jellemzőit. Az általános információátadás mellett, az applikáció célja, hogy a Budai Campus hallgatói már szakmai kérdésekre is választ kapjanak, mint például a taxon ökológiai igényei, szaporítása, alkalmazási lehetőségeit és részletes fenológiai fázisait. Ezen információk jelentősen megkönnyítik, hogy kertészeti és tájépítészeti szempontból is megismerjük a növényeket.',
                    textAlign: TextAlign.justify,
                  )),
              FoMenuButton(
                cimke: "Barangolás a térképen",
                ikon: Icons.map,
                onPress: Consumer<ApplicationState>(
                  builder: (context, appState, _) => const Terkep(),
                ),
              ),
              FoMenuButton(
                cimke: "Növény keresése",
                ikon: Icons.search,
                onPress: Consumer<ApplicationState>(
                  builder: (context, appState, _) => const Search(),
                ),
              ),
              if (appState.loginState == LoginState.loggedIn) ...[
                FoMenuButton(
                  cimke: "Saját jegyzeteim",
                  ikon: Icons.notes,
                  onPress: Consumer<ApplicationState>(
                    builder: (context, appState, _) => const Notes(),
                  ),
                )
              ],
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
                        deleteAcc: appState.deleteAcc,
                        resetPassword: appState.resetPassword)),
              ),
            ],
            footer: Footer(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text('Verzió: ' + appState.version),
            )));
  }
}

class FoMenuButton extends StatelessWidget {
  const FoMenuButton(
      {Key? key,
      required this.cimke,
      required this.ikon,
      required this.onPress})
      : super(key: key);

  final String cimke;
  final IconData ikon;
  final Widget onPress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
          label: Text(cimke),
          icon: Icon(ikon, size: 20),
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(300, 30),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => onPress));
          }),
    );
  }
}
