import 'package:arborapp/src/applicationState.dart';
import 'package:arborapp/src/plant.dart';
import 'package:arborapp/src/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class QrReader extends StatefulWidget {
  const QrReader({Key? key}) : super(key: key);

  @override
  QrReaderState createState() => QrReaderState();
}

class QrReaderState extends State<QrReader> {
  Future<void> scanQR(ApplicationState appState) async {
    Noveny? novenyRes;
    try {
      String novenyId = await FlutterBarcodeScanner.scanBarcode(
          '#00FF00', 'Mégsem', true, ScanMode.QR);
      novenyRes = appState.getNovenyByIdString(novenyId);
    } on PlatformException {
      novenyRes = null;
    }

    if (!mounted) return;

    setState(() {
      if (novenyRes != null) {
        megnyitasPopup(novenyRes);
      } else {
        errorPopup();
      }
    });
  }

  void errorPopup() {
    showDialog<void>(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text(
              'Hiba a QR kód beolvasása közben',
              style: TextStyle(fontSize: 18),
            ),
            content: Text(
              'Próbáld újra',
              style: TextStyle(fontSize: 13),
            ),
          );
        });
  }

  void megnyitasPopup(Noveny noveny) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            noveny.nev,
            style: const TextStyle(fontSize: 18),
          ),
          content: Text(
            noveny.tipus.name,
            style: const TextStyle(fontSize: 13),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Mégsem'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // close popup
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Plant(noveny: noveny)));
              },
              child: const Text('Megnyitás'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);

    return Scaffold(
        appBar: AppBar(title: const Text('Keresés QR kód alapján')),
        body: Builder(builder: (BuildContext context) {
          return Container(
              alignment: Alignment.center,
              child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        autofocus: true,
                        onPressed: () => scanQR(appState),
                        child: const Text('Beolvasás'))
                  ]));
        }));
  }
}
