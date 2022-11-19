import 'package:arborapp/src/enums.dart';
import 'package:arborapp/src/error.dart';
import 'package:arborapp/src/load.dart';
import 'package:arborapp/src/plant.dart';
import 'package:arborapp/src/types.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'applicationState.dart';

class Terkep extends StatelessWidget {
  const Terkep({this.novenyId, super.key});

  final DocumentReference? novenyId;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    final List<Noveny> novenyek = appState.novenyek;

    return FutureBuilder<List<NovenyKoordinata>>(
        future: appState.loadNovenyKoordinatak(novenyId),
        builder: (BuildContext context,
            AsyncSnapshot<List<NovenyKoordinata>> novenyKoordSnapshot) {
          switch (novenyKoordSnapshot.connectionState) {
            case ConnectionState.waiting:
              return const LoadingScreen(cim: 'Térkép');
            default:
              if (novenyKoordSnapshot.hasError) {
                return ErrorScreen(hiba: novenyKoordSnapshot.error);
              } else {
                return _ShowMap(
                    novenyek: novenyek, koords: novenyKoordSnapshot.data);
              }
          }
        });
  }
}

class _ShowMap extends StatefulWidget {
  const _ShowMap({required this.novenyek, required this.koords});

  final List<Noveny> novenyek;
  final List<NovenyKoordinata>? koords;

  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<_ShowMap> {
  late List<Marker> markers;
  late List<NovenyTipus> novenyTipusok;

  @override
  void initState() {
    novenyTipusok = List.from(NovenyTipus.values);
    filterMarkers();
    super.initState();
  }

  void filterMarkers() {
    List<Marker> showMarkers = [];

    for (var koord in widget.koords!) {
      Noveny noveny =
          widget.novenyek.where((n) => n.id == koord.novenyId).single;
      if (novenyTipusok.contains(noveny.tipus)) {
        showMarkers.add(Marker(
            point: LatLng(koord.coords.latitude, koord.coords.longitude),
            builder: (context) => _MapMarker(noveny)));
      }
    }

    markers = showMarkers;
  }

  Widget oldalMenu() {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            padding: EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 0.0),
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.rectangle,
            ),
            child: Text('A térképen megjelenő növénytípusok',
                style: TextStyle(color: Colors.white)),
          ),
          for (NovenyTipus tipus in NovenyTipus.values) ...[
            Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  value: novenyTipusok.contains(tipus),
                  onChanged: (bool? ujErtek) => {
                    setState(() {
                      ujErtek!
                          ? novenyTipusok.add(tipus)
                          : novenyTipusok.remove(tipus);
                      filterMarkers();
                    })
                  },
                ),
                Text(tipus.nev)
              ],
            )
          ]
        ],
      ),
    );
  }

  void jelmagyarazatPopup() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Jelmagyarázat',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  for (NovenyTipus i in NovenyTipus.values) ...[
                    Row(
                      children: [
                        Icon(Icons.circle, color: i.szin),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0)),
                        Text(i.nev)
                      ],
                    )
                  ]
                ])));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Térkép',
          ),
        ),
        drawer: oldalMenu(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            jelmagyarazatPopup();
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.info),
        ),
        body: FlutterMap(
          options: MapOptions(
              center: LatLng(47.4810700, 19.0393743),
              zoom: 16.0,
              minZoom: 16,
              maxZoom: 19,
              maxBounds: LatLngBounds(LatLng(47.4753677, 19.0298865),
                  LatLng(47.4890959, 19.0470638))),
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap contributors',
              onSourceTapped: null,
            ),
          ],
          children: [
            TileLayer(
                opacity: 0.8,
                minZoom: 16,
                maxZoom: 19,
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileBounds: LatLngBounds(LatLng(47.4753677, 19.0298865),
                    LatLng(47.4890959, 19.0470638))),
            MarkerLayer(markers: markers),
          ],
        ));
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker(this.noveny);

  final Noveny noveny;

  void mapMarkerPopup(BuildContext context, Noveny noveny) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            noveny.nev,
            style: const TextStyle(fontSize: 18),
          ),
          content: Text(
            noveny.tipus.nev,
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
    return TextButton(
        onPressed: () {
          mapMarkerPopup(context, noveny);
        },
        child: Icon(
          Icons.eco,
          color: noveny.tipus.szin,
          size: 14,
        ));
  }
}
