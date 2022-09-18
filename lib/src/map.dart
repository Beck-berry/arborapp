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
                return _ShowMap(novenyek: novenyKoordSnapshot.data);
              }
          }
        });
  }
}

class _ShowMap extends StatelessWidget {
  const _ShowMap({required this.novenyek});

  final List<NovenyKoordinata>? novenyek;

  void jelmagyarazatPopup(BuildContext context) {
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
                        Text(i.name)
                      ],
                    )
                  ]
                ])));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    List<Marker> markers = getAllMarkers(appState, novenyek!);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Térkép',
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            jelmagyarazatPopup(context);
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.navigation),
        ),
        body: FlutterMap(
          options: MapOptions(
              center: LatLng(47.4810700, 19.0393743),
              zoom: 16.0,
              minZoom: 16,
              maxZoom: 19,
              maxBounds: LatLngBounds(LatLng(47.4753677, 19.0298865),
                  LatLng(47.4890959, 19.0470638))),
          layers: [
            TileLayerOptions(
                minZoom: 16,
                maxZoom: 19,
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                tileBounds: LatLngBounds(LatLng(47.4753677, 19.0298865),
                    LatLng(47.4890959, 19.0470638))),
            MarkerLayerOptions(markers: markers),
          ],
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap contributors',
              onSourceTapped: null,
            ),
          ],
        ));
  }
}

List<Marker> getAllMarkers(appState, List<NovenyKoordinata> novenyek) {
  List<Marker> allMarkers = [];

  for (var n in novenyek) {
    Noveny noveny = appState.getNovenyById(n.novenyId);

    allMarkers.add(Marker(
        point: LatLng(n.coords.latitude, n.coords.longitude),
        builder: (context) => _MapMarker(noveny)));
  }

  return allMarkers;
}

class _MapMarker extends StatelessWidget {
  const _MapMarker(this.noveny);

  final Noveny noveny;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          mapMarkerPopup(context, noveny);
        },
        child: Icon(
          Icons.circle,
          color: noveny.tipus.szin,
          size: 12,
        ));
  }
}

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
