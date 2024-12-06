import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/polylinemodel.dart';

class DetailsClient extends StatefulWidget {
  const DetailsClient({super.key});

  @override
  State<DetailsClient> createState() => _DetailState();
}

class _DetailState extends State<DetailsClient> {
  List data = [];
  List datasin = [];
  LatLng origin = const LatLng(33.725042, 10.748786);
  LatLng destination = const LatLng(33.731946, 10.746233);

  TextEditingController comm = TextEditingController();

  String totalDistance = "";
  String totalTime = "";

  String apiKey = "AIzaSyBOaG6xg7CMEQbOuqRQ0NzSA-fsq2Wzsqs";

  PolylineResponse polylineResponse = PolylineResponse();

  Set<Polyline> polylinePoints = {};

  List<LatLng> polylineCoordinates = [];

  bool t = true;

  Future getAdresse(
    String idcoli,
  ) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/getAdresseColis'),
      body: {
        'idcoli': idcoli.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        data.add(ok);
      });
    }
  }

  Future signle(idclient, idlivreur, idcoli, message) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/problemClient'),
      body: {
        'idclient': idclient.toString(),
        'idlivreur': idlivreur.toString(),
        'idcoli': idcoli.toString(),
        'message': message.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        datasin.add(ok);
      });
    }
  }

  LatLng? currentPostion;

  /*Future getPosition() async {
    bool services;

    services = await Geolocator.isLocationServiceEnabled();

    if (services == false) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('An error occurred'),
              content: Text('Your location button is disabled'),
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
        setState(() {
          _getUserLocation();
        });
      }
    }
  }

  _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }*/
  //'AIzaSyBOaG6xg7CMEQbOuqRQ0NzSA-fsq2Wzsqs'

  BitmapDescriptor markerIcondistination = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconcoli = BitmapDescriptor.defaultMarker;

  void addmarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/des.png")
        .then(
      (icon) {
        markerIcondistination = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/coli.png")
        .then(
      (icon) {
        markerIconcoli = icon;
      },
    );
  }

  @override
  void initState() {
    addmarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final idcolis = args['idcoli'];
    final idclient = args['idclient'];
    final idlivreur = args['idlivreur'];
    final reference = args['ref'];
    final description = args['des'];
    final namelivreur = args['namelivreur'];
    final phonelivreur = args['phonelivreur'];
    final taille = args['taille'];
    final type = args['type'];
    final prix = args['prix'];
    final distance = args['distance'];
    final adR = args['adR'];
    final adE = args['adE'];

    //final date = args['date'];

    if (t) {
      getAdresse(idcolis.toString());
      setState(() {
        t = false;
      });
    }
    if (data.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      setState(() {
        origin = LatLng(
            double.parse(data[0]['latE']), double.parse(data[0]['longE']));
        destination = LatLng(
            double.parse(data[0]['latR']), double.parse(data[0]['longR']));
        // drawPolyline();
      });

      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Contacter Nous ?'),
                      content: TextFormField(
                        controller: comm,
                        decoration: InputDecoration(
                          hintText: 'Commentaire',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Envoyer'),
                          onPressed: () async {
                            await signle(
                                idclient, idlivreur, idcolis, comm.text);
                            if (datasin[0]['succes'] == 'succes') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Container(
                                      padding: EdgeInsets.all(16),
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "Message envoyé ",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ))),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ),
                              );
                            }
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.notification_important,
                color: Colors.red,
                size: 30,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.black12,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black87),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 4,
                        offset: Offset(3, 3), // Shadow position
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(10),
                  height: 200,
                  width: double.infinity,
                  child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(double.parse(data[0]['latE']),
                            double.parse(data[0]['longE'])),
                        zoom: 9,
                      ),
                      polylines: polylinePoints,
                      markers: {
                        Marker(
                          infoWindow: InfoWindow(title: 'Debut'),
                          icon: markerIconcoli,
                          markerId: MarkerId('1'),
                          position: LatLng(double.parse(data[0]['latE']),
                              double.parse(data[0]['longE'])),
                        ),
                        Marker(
                          infoWindow: InfoWindow(title: 'Destination'),
                          icon: markerIcondistination,
                          markerId: MarkerId('2'),
                          position: LatLng(double.parse(data[0]['latR']),
                              double.parse(data[0]['longR'])),
                        ),
                      }),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white12),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 4,
                        offset: Offset(3, 3), // Shadow position
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          border: Border(bottom: BorderSide(width: 1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Reference :",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text("$reference",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          border: Border(bottom: BorderSide(width: 1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nom de livreur :",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text("Mr : $namelivreur",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          border: Border(bottom: BorderSide(width: 1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Numero de livreur :",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text("+$phonelivreur",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87)),
                              ],
                            ),
                            FloatingActionButton(
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                launch("tel://+$phonelivreur");
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          border: Border(bottom: BorderSide(width: 1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Adresse Ramassage :",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text("$adR.",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          border: Border(bottom: BorderSide(width: 1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Adresse Distination :",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text("$adE.",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          border: Border(bottom: BorderSide(width: 1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description :",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text("$description.",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          border: Border(bottom: BorderSide(width: 1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Type :",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text("Coli $type.",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          border: Border(bottom: BorderSide(width: 1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Taille :",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text("$taille.",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          border: Border(bottom: BorderSide(width: 1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Distance de trajet :",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text("$distance KM.",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white60,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Prix final:",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text("$prix TND.",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void drawPolyline() async {
    var response = await http.post(Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?key=" +
            apiKey +
            "&units=metric&origin=" +
            origin.latitude.toString() +
            "," +
            origin.longitude.toString() +
            "&destination=" +
            destination.latitude.toString() +
            "," +
            destination.longitude.toString() +
            "&mode=driving"));

    print(response.body);

    polylineResponse = PolylineResponse.fromJson(jsonDecode(response.body));

    totalDistance = polylineResponse.routes![0].legs![0].distance!.text!;
    totalTime = polylineResponse.routes![0].legs![0].duration!.text!;

    for (int i = 0;
        i < polylineResponse.routes![0].legs![0].steps!.length;
        i++) {
      polylinePoints.add(Polyline(
          polylineId: PolylineId(
              polylineResponse.routes![0].legs![0].steps![i].polyline!.points!),
          points: [
            LatLng(
                polylineResponse
                    .routes![0].legs![0].steps![i].startLocation!.lat!,
                polylineResponse
                    .routes![0].legs![0].steps![i].startLocation!.lng!),
            LatLng(
                polylineResponse
                    .routes![0].legs![0].steps![i].endLocation!.lat!,
                polylineResponse
                    .routes![0].legs![0].steps![i].endLocation!.lng!),
          ],
          width: 3,
          color: Colors.red));
    }

    setState(() {});
  }
}
