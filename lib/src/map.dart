import 'package:arborapp/src/enums.dart';
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
  const Terkep({Key? key}) : super(key: key);

  Future<List<NovenyKoordinata>> loadNovenyKoordinatak(appState) async {
    return await appState.initKoordinatak();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);

    return FutureBuilder<List<NovenyKoordinata>>(
        future: loadNovenyKoordinatak(appState),
        builder: (BuildContext context,
            AsyncSnapshot<List<NovenyKoordinata>> novenyKoordSnapshot) {
          switch (novenyKoordSnapshot.connectionState) {
            case ConnectionState.waiting:
              return const Text('Loading....');
            default:
              if (novenyKoordSnapshot.hasError) {
                return Text('Error: ${novenyKoordSnapshot.error}');
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

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = getAllMarkers(novenyek!);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Térkép',
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO jelmagyarázat? vagy valami infó a térképhez
          },
        backgroundColor: Colors.green,
        child: const Icon(Icons.navigation),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(47.4804872, 19.0379859),
          zoom: 16.0,
          minZoom: 16,
          maxZoom: 19,
        ),
        layers: [
          TileLayerOptions(
            minZoom: 16,
            maxZoom: 19,
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
              markers: markers
          ),
        ],
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: 'OpenStreetMap contributors',
            onSourceTapped: null,
          ),
        ],
      )
    );
  }
}

List<Marker> getAllMarkers(List<NovenyKoordinata> novenyek) {
  List<Marker> allMarkers = [];

  for (var n in novenyek) {
    allMarkers.add(Marker(
        point: LatLng(n.coords.latitude, n.coords.longitude),
        builder: (context) => _MapMarker(n.novenyId)));
  }

  return allMarkers;
}

class _MapMarker extends StatelessWidget {
  const _MapMarker(this.novenyId);

  final DocumentReference novenyId;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);

    Noveny noveny = appState.novenyek.where((n) => n.id == novenyId).single;

    return TextButton(
        onPressed: () {
          mapMarkerPopup(context, appState, noveny);
        },
        child: Icon(
          Icons.circle,
          color: noveny.tipus.szin,
          size: 12,
        ));
  }
}

void mapMarkerPopup(BuildContext context, appState, Noveny noveny) {
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
              Noveny kivalasztottNoveny =
                  appState.novenyek.where((n) => noveny.id == n.id).first;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Plant(noveny: kivalasztottNoveny)));
            },
            child: const Text('Megnyitás'),
          ),
        ],
      );
    },
  );
}