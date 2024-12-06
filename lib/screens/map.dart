import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map1 extends StatefulWidget {
  const Map1({super.key});

  @override
  State<Map1> createState() => _MAPState();
}

class _MAPState extends State<Map1> {
  bool test = false;
  /*Future getPosition() async {
    bool services;

    services = await Geolocator.isLocationServiceEnabled();

    if (services == false) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('An error occurred'),
              content: Text('Location Is enabled'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always) {
        getlocation();
      }
    }
  }*/

  /* Future<Position> getlocation() async {
    return await Geolocator.getCurrentPosition().then((value) => value);
  }*/

  late GoogleMapController gm;
  LatLng pos = LatLng(33.886917, 9.537499);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(33.807598, 10.845147),
          zoom: 13,
        ),
        onMapCreated: (GoogleMapController controller) {
          gm = controller;
        },
        onTap: (argument) {
          setState(() {
            test = true;
            pos = argument;
          });
        },
        markers: {
          Marker(
            markerId: MarkerId('1'),
            position: pos,
            draggable: true,
          )
        },
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 30,
        ),
        child: Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          width: double.infinity,
          child: MaterialButton(
            height: 60,
            color: Colors.amber,
            child: Text(
              'Confirmer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              if (test == false) {
                return null;
              } else {
                Navigator.pop(context, pos);
              }
            },
          ),
        ),
      ),
    ]);
  }
}
