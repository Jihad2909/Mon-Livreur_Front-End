import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'homeLivreur.dart';

class MapLiteraire extends StatefulWidget {
  const MapLiteraire({super.key});

  @override
  State<MapLiteraire> createState() => _MapLiteraireState();
}

class _MapLiteraireState extends State<MapLiteraire> {
  List datacoli = [];
  List etatcoli = [];
  List rejetercoli = [];
  bool not1 = false;
  bool not2 = true;
  bool not3 = true;
  bool not4 = true;
  List data = [];
  String message = '';
  bool t = true;
  double km = 0.0;
  bool vesible = false;
  int _selectednotfi = 1;
  TextEditingController rejeter = TextEditingController();

  LatLng lat2 = LatLng(0.0, 0.0);
  LocationData? currentlocation;

  BitmapDescriptor markerIconlivreur = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcondistination = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconcoli = BitmapDescriptor.defaultMarker;

  void addmarkerlivreur() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "assets/images/my.png",
    ).then(
      (icon) {
        markerIconlivreur = icon;
      },
    );
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

  void getcurrentlocation() {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentlocation = location;
      },
    );
    location.onLocationChanged.listen((event) {
      currentlocation = event;
      km = calculateDistance(currentlocation!.latitude,
          currentlocation!.longitude, lat2.latitude, lat2.longitude);
      if (this.mounted) {
        setState(() {});
      }
    });
  }

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

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a)));
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
      var ok = jsonDecode(response.body);
      setState(() {
        etatcoli.add(ok);
      });
    }
  }

  Future rejeterLivreur(
    String idcoli,
    String idlivreur,
    String idclient,
    String message,
  ) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/rejeterLivreurEtat'),
      body: {
        'idcoli': idcoli.toString(),
        'idlivreur': idlivreur.toString(),
        'idclient': idclient.toString(),
        'message': message.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        rejetercoli.add(ok);
      });
    }
  }

  Future notifierClient(
    String idcoli,
    String idlivreur,
    String idclient,
    String message,
  ) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/notifierClient'),
      body: {
        'idcoli': idcoli.toString(),
        'idlivreur': idlivreur.toString(),
        'idclient': idclient.toString(),
        'message': message.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        rejetercoli.add(ok);
      });
    }
  }

  @override
  void initState() {
    // getPosition();
    getcurrentlocation();
    addmarkerlivreur();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final idcoli = args['idcoli'];
    final idlivreur = args['idlivreur'];
    final idclient = args['idclient'];

    if (t) {
      getAdresse(idcoli.toString());
      setState(() {
        t = false;
      });
    }
    if (data.isEmpty || currentlocation == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      lat2 =
          LatLng(double.parse(data[0]['latE']), double.parse(data[0]['longE']));

      return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(data[0]['latE']),
                    double.parse(data[0]['longE'])),
                zoom: 11.800,
              ),
              markers: {
                Marker(
                  visible: true,
                  icon: markerIconlivreur,
                  infoWindow: InfoWindow(title: 'Moi'),
                  markerId: const MarkerId('1'),
                  position: LatLng(
                      currentlocation!.latitude!, currentlocation!.longitude!),
                ),
                Marker(
                  visible: true,
                  icon: markerIconcoli,
                  infoWindow: InfoWindow(title: 'Debut'),
                  markerId: MarkerId('2'),
                  position: LatLng(double.parse(data[0]['latE']),
                      double.parse(data[0]['longE'])),
                ),
                Marker(
                  markerId: MarkerId('3'),
                  icon: markerIcondistination,
                  infoWindow: InfoWindow(title: 'Distination'),
                  position: LatLng(double.parse(data[0]['latR']),
                      double.parse(data[0]['longR'])),
                ),
              },
            ),
            Positioned(
              top: 50,
              left: 10,
              child: Container(
                padding: EdgeInsets.only(left: 20, top: 10),
                width: 220,
                height: 100,
                color: Colors.white38,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Récuperer coli  ",
                      style: TextStyle(fontSize: 18, color: Colors.green),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.motorcycle),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${km.toStringAsFixed(2)}.km",
                          style: TextStyle(fontSize: 16, color: Colors.purple),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              right: 10,
              child: FloatingActionButton(
                heroTag: "btn2",
                backgroundColor: Colors.red,
                child: Text('Rejeter'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Pour Quelle Raison ?'),
                          content: TextFormField(
                            controller: rejeter,
                            onTapOutside: (event) {
                              message = rejeter.text;
                            },
                            decoration: InputDecoration(
                              hintText: 'Commentaire',
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Envoyer'),
                              onPressed: () async {
                                await rejeterLivreur(
                                    idcoli.toString(),
                                    idlivreur.toString(),
                                    idclient.toString(),
                                    message.toString());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Container(
                                      padding: EdgeInsets.all(16),
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Coli rejeter!",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ),
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
            ),
            Positioned(
              bottom: 220,
              right: 10,
              child: FloatingActionButton(
                heroTag: "btn3",
                backgroundColor: Colors.green,
                child: Text('livrer'),
                onPressed: () async {
                  await updateLivreurEtat(
                      idcoli.toString(), idlivreur.toString(), '5');
                  if (etatcoli[0]['succes'] == 'succes') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 1),
                        content: Container(
                          padding: EdgeInsets.all(16),
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Text(
                              "Coli livrer ",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              HomeLivreur(iduser: int.parse(idlivreur)),
                        ),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 1),
                        content: Container(
                          padding: EdgeInsets.all(16),
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Text(
                              "verifier vous donnée",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            Positioned(
              top: 150,
              right: 10,
              child: FloatingActionButton(
                heroTag: "btn4",
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.notification_add,
                  color: Colors.black,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text('Notifier le Client'),
                          content: Container(
                            width: 300,
                            height: 180,
                            child: Column(
                              children: [
                                RadioListTile(
                                  title:
                                      Text('en route pour récupérer le colis'),
                                  value: 1,
                                  groupValue: _selectednotfi,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  onChanged: not1
                                      ? null
                                      : (value) => _selectednotfi = 1,
                                ),
                                RadioListTile(
                                  title: Text('Colis récupéré'),
                                  groupValue: _selectednotfi,
                                  value: 2,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  onChanged: not2
                                      ? null
                                      : (value) => _selectednotfi = 2,
                                ),
                                RadioListTile(
                                  title: Text('en route vers le destinateur'),
                                  groupValue: _selectednotfi,
                                  value: 3,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  onChanged: not3
                                      ? null
                                      : (value) => _selectednotfi = 3,
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            if (_selectednotfi == 4)
                              Text(
                                'Vous avez notifer le Client',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 143, 50, 43),
                                ),
                              ),
                            if (_selectednotfi != 4)
                              TextButton(
                                child: Text(
                                  'Envoyer',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 143, 50, 43),
                                  ),
                                ),
                                onPressed: () async {
                                  await notifierClient(
                                      idcoli.toString(),
                                      idlivreur.toString(),
                                      idclient.toString(),
                                      _selectednotfi.toString());
                                  if (rejetercoli[0]['succes'] == 'succes') {
                                    if (_selectednotfi == 1) {
                                      setState(() {
                                        _selectednotfi = 2;
                                        not1 = true;
                                        not2 = false;
                                      });
                                    } else if (_selectednotfi == 2) {
                                      setState(() {
                                        _selectednotfi = 3;
                                        not2 = true;
                                        not3 = false;
                                      });
                                    } else if (_selectednotfi == 3) {
                                      setState(() {
                                        _selectednotfi = 4;
                                        not3 = true;
                                      });
                                    }
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
                                              "Notfication Envoyer ",
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ))),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Container(
                                            padding: EdgeInsets.all(16),
                                            height: 90,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              "Notfication non envoyer ",
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ))),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                          ],
                        );
                      });
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
