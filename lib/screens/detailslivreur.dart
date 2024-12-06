import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/polylinemodel.dart';

class DetailsLivreur extends StatefulWidget {
  const DetailsLivreur({super.key});

  @override
  State<DetailsLivreur> createState() => _DetailState();
}

class _DetailState extends State<DetailsLivreur> {
  List data = [];
  LatLng origin = const LatLng(33.725042, 10.748786);
  LatLng destination = const LatLng(33.731946, 10.746233);

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

  Future updateLivreurEtat(
    String idcoli,
    String idlivreur,
    String idetatcoli,
  ) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/UpdateLivreurEtat'),
      body: {
        'idcoli': idcoli.toString(),
        'idlivreur': idlivreur.toString(),
        'idetatcoli': idetatcoli.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      var ok = jsonDecode(response.body);
    }
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
    final idlivreur = args['idlivreur'];
    final reference = args['ref'];
    final description = args['des'];
    final nameclient = args['nameclient'];
    final taille = args['taille'];
    final type = args['type'];
    final etat = args['etat'];
    final prix = args['prix'];
    final distance = args['distance'];
    final adR = args['adR'];
    final adE = args['adE'];
    final numE = args['numE'];
    final numR = args['numR'];
    final idclient = args['idclient'];
    final msg = args['msg'];

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
            title: Text('$msg'),
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
                            icon: markerIconcoli,
                            markerId: MarkerId('1'),
                            position: LatLng(double.parse(data[0]['latE']),
                                double.parse(data[0]['longE'])),
                          ),
                          Marker(
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
                              Text("Publié par :",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              Text("Mr : $nameclient",
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
                              Text("Adresse de ramassage :",
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
                              Text("Adresse de distination :",
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Numero de l'envoyeur :",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  Text("$numE",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black87)),
                                ],
                              ),
                              FloatingActionButton(
                                heroTag: 'btn1',
                                backgroundColor: Colors.black,
                                child: Icon(Icons.phone),
                                onPressed: () {
                                  launch("tel://+216$numE");
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Numero de recepteur :",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  Text("+216 $numR",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black87)),
                                ],
                              ),
                              FloatingActionButton(
                                heroTag: 'btn2',
                                backgroundColor: Colors.black,
                                child: Icon(Icons.phone),
                                onPressed: () {
                                  launch("tel://+216$numR");
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
                              Text("Distance trajet :",
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
          bottomNavigationBar: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 3, color: Colors.white),
            ),
            height: 45,
            child: Stack(
              children: [
                if (etat == 'Accepter')
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pushNamed(context, '/mapliteraire',
                              arguments: {
                                'idcoli': idcolis,
                                'idlivreur': idlivreur,
                                'idclient': idclient,
                              });
                          await updateLivreurEtat(
                              idcolis.toString(), idlivreur.toString(), '3');
                        },
                        child: Text(
                          'Commencer',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                  ),
                if (etat == 'En Cours')
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/mapliteraire',
                              arguments: {
                                'idcoli': idcolis,
                                'idlivreur': idlivreur,
                                'idclient': idclient,
                              });
                        },
                        child: Text(
                          'Reprendre',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                  ),
              ],
            ),
          ));
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
