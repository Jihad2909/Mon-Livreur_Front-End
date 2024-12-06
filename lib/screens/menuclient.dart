import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monlivreur/screens/map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MenuClient extends StatefulWidget {
  const MenuClient({super.key});

  @override
  State<MenuClient> createState() => _MenuState();
}

class _MenuState extends State<MenuClient> {
  List data = [];
  List dataAccepte = [];
  List datarefuse = [];
  List dataprix = [];
  List datauser = [];
  List data2 = [];
  List naturecolis = [];
  int _selectedValueNature = 1;
  int _selectedValueTaille = 1;
  int _selectedValuetype = 1;
  int iduser = 0;
  String idcoli = '0';
  bool isobpassword = false;
  bool t = true;

  TextEditingController fullnameE = TextEditingController();
  TextEditingController emailE = TextEditingController();
  TextEditingController phonenumberE = TextEditingController();
  TextEditingController placeE = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController fullnameR = TextEditingController();
  TextEditingController emailR = TextEditingController();
  TextEditingController phonenumberR = TextEditingController();
  TextEditingController placeR = TextEditingController();

  TextEditingController prixc = TextEditingController();
  TextEditingController price = TextEditingController();

  final controller = PageController();
  bool isColis = false;
  bool isSetting = false;
  bool addColis = false;
  int currentStep = 0;
  double km = 0.0;
  String kmd = '';
  String prix = '0';
  String prixclient = '0';
  double _price = 0;
  bool nature1 = false;
  bool nature2 = false;
  bool nature3 = false;
  Map datacoli = {};
  String messageetat = '';
  late LatLng _SendLocation;
  late LatLng _DestinationLocation;

  Future getuser(String iduser) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/getUser'),
      body: {
        'iduser': iduser.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        datauser.add(ok);
      });
    } 
  }

  Future savecoli(Map datacoli) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/colis'),
      body: {
        'iduser': datacoli['iduser'].toString(),
        'description': datacoli['description'],
        'idtaillecoli': _selectedValueTaille.toString(),
        'idtypecoli': _selectedValuetype.toString(),
        'prixbase': datacoli['prixbase'],
        //'date': '20',
        //'time': '20',
        'fullname': datacoli['fullnameE'],
        'email': datacoli['emailE'],
        'phonenumber': datacoli['phonenumberE'],
        'fullnamer': datacoli['fullnameR'],
        'emailr': datacoli['emailR'],
        'phonenumberr': datacoli['phonenumberR'],
        'adresse': datacoli['placeE'],
        'longitude': _SendLocation.longitude.toString(),
        'latitude': _SendLocation.latitude.toString(),
        'adresser': datacoli['placeR'],
        'longituder': _DestinationLocation.longitude.toString(),
        'latituder': _DestinationLocation.latitude.toString(),
        'idnature': _selectedValueNature.toString(),
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

  Future coliEtat(iduser, String etat) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/getColiEtat'),
      body: {'iduser': iduser.toString(), 'etatcoli': etat.toString()},
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      return ok;
    }
  }

  Future attente(idclient) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/EnattenteClient'),
      body: {
        'idclient': idclient.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      return ok;
    }
  }

  Future acceptecoli(idcoli, idlivreur, prixfinal) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/AccepteColiClient'),
      body: {
        'idcoli': idcoli.toString(),
        'idlivreur': idlivreur.toString(),
        'prixfinal': prixfinal.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        dataAccepte.add(ok);
      });
    }
  }

  Future refusecoli(idcoli, idlivreur) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/RefuseColiClient'),
      body: {
        'idcoli': idcoli.toString(),
        'idlivreur': idlivreur.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        datarefuse.add(ok);
      });
    }
  }

  Future etat2et3(idclient) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/getColiEtat2et3Client'),
      body: {
        'idclient': idclient.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      return ok;
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

  String CalculePrix(km) {
    return prix = (0.5 * km).toString();
  }

  Future updatePrix(idcoli, prixclient) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/updatePrix'),
      body: {'idcoli': idcoli.toString(), 'prixclient': prixclient.toString()},
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        dataprix.add(ok);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String iduser = args['iduser'];

    if (t) {
      getuser(iduser.toString());
      setState(() {
        t = false;
      });
    }
    if (datauser.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      print(datauser);
      return Scaffold(
        body: PageView(
          controller: controller,
          children: [
            Visibility(
              visible: true,
              child: DefaultTabController(
                length: 4,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: Center(child: Text('Colis')),
                    bottom: TabBar(tabs: [
                      Tab(
                        icon: Icon(Icons.run_circle),
                        text: 'En Cours',
                      ),
                      Tab(
                        icon: Icon(Icons.stop),
                        text: 'En attente',
                      ),
                      Tab(
                        icon: Icon(Icons.rule),
                        text: 'Rejeter',
                      ),
                      Tab(
                        icon: Icon(Icons.done),
                        text: 'Livré',
                      ),
                    ]),
                  ),
                  body: TabBarView(children: [
                    Encours(iduser.toString()),
                    Enattente(iduser.toString()),
                    Rejeter(iduser.toString()),
                    Livrer(iduser.toString()),
                  ]),
                ),
              ),
            ),
            Visibility(
                visible: true,
                child: Container(
                    color: Colors.black12,
                    child: Stepper(
                      onStepTapped: (value) =>
                          setState(() => currentStep = value),
                      type: StepperType.vertical,
                      steps: getSteps(),
                      currentStep: currentStep,
                      onStepContinue: () async {
                        if (currentStep == 6) {
                          km = calculateDistance(
                              _SendLocation.latitude,
                              _SendLocation.longitude,
                              _DestinationLocation.latitude,
                              _DestinationLocation.longitude);

                          prix = CalculePrix(km.round());
                          prixclient = double.parse(prix).round().toString();
                          if (double.parse(prix).round() <= 3) {
                            setState(() {
                              prix = '3';
                            });
                          } else {
                            setState(() {
                              prix = double.parse(prix).round().toString();
                            });
                          }
                          _price = double.parse(prix);

                          datacoli = {
                            'iduser': iduser.toString(),
                            'fullnameE': fullnameE.text,
                            'emailE': emailE.text,
                            'phonenumberE': phonenumberE.text,
                            'placeE': placeE.text,
                            'fullnameR': fullnameR.text,
                            'emailR': emailR.text,
                            'phonenumberR': phonenumberR.text,
                            'placeR': placeR.text,
                            'description': description.text,
                            'idnature': _selectedValueNature,
                            'prixbase': prix,
                          };

                          await savecoli(datacoli);

                          if (data.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 1),
                                content: Container(
                                    padding: EdgeInsets.all(16),
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Problem de sauvegardé la Coli ! ",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ))),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                            );
                          } else {
                            idcoli = data[0]['idcoli'].toString();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 1),
                                content: Container(
                                    padding: EdgeInsets.all(16),
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                        child: Column(
                                      children: [
                                        Text(
                                          "Coli Sauvegarder dans brouillon ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "Merci du confirmé votre prix !",
                                          style: TextStyle(
                                            fontSize: 19,
                                            color: Colors.blue,
                                          ),
                                        )
                                      ],
                                    ))),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                            );
                          }
                        } else {
                          setState(() {
                            currentStep += 1;
                          });
                        }
                      },
                      onStepCancel: () {
                        setState(() => currentStep -= 1);
                      },
                      controlsBuilder: (context, details) {
                        final _is6Step = currentStep == getSteps().length - 2;

                        return Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Row(children: [
                              if (currentStep != 7)
                                Expanded(
                                    child: ElevatedButton(
                                        child: Text(_is6Step ? 'Send' : 'Next'),
                                        onPressed: details.onStepContinue)),
                              const SizedBox(
                                width: 12,
                              ),
                              if (currentStep != 0 && currentStep != 7)
                                Expanded(
                                    child: ElevatedButton(
                                        child: Text('Back'),
                                        onPressed: details.onStepCancel))
                            ]));
                      },
                    ))),
            Visibility(
              visible: true,
              child: Container(
                color: Colors.black12,
                padding: EdgeInsets.only(left: 15, top: 20, right: 15),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 4, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                  )
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/phone.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Colors.white,
                                    ),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(Icons.edit, color: Colors.white),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text('blala|blala|blala',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      TextFormField(
                        readOnly: true,
                        initialValue: datauser[0]['name'].toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontSize: 19,
                          ),
                          contentPadding: EdgeInsets.only(bottom: 5),
                          labelText: 'Full Name',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        readOnly: true,
                        initialValue: datauser[0]['email'].toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontSize: 19,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/upemail',
                                    arguments: {'iduser': iduser.toString()});
                              },
                              icon: Icon(Icons.edit)),
                          contentPadding: EdgeInsets.only(bottom: 5),
                          labelText: 'Email',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        readOnly: true,
                        initialValue: '********',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontSize: 19,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/upPassword',
                                    arguments: {'id': iduser.toString()});
                              },
                              icon: Icon(Icons.edit)),
                          contentPadding: EdgeInsets.only(bottom: 5),
                          labelText: 'Password',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        readOnly: true,
                        initialValue: datauser[0]['phone'].toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontSize: 19,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/upPhone',
                                    arguments: {'iduser': iduser.toString()});
                              },
                              icon: Icon(Icons.edit)),
                          contentPadding: EdgeInsets.only(bottom: 5),
                          labelText: 'Phone Number',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          margin: EdgeInsets.only(bottom: 1),
          height: 50,
          color: Colors.black26,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    controller.jumpToPage(0);
                    setState(() {
                      isColis = true;
                      isSetting = false;
                      addColis = false;
                    });
                  },
                  icon: Icon(Icons.card_travel),
                ),
                Text(
                  'Colis',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    controller.jumpToPage(1);
                    setState(() {
                      isColis = false;
                      isSetting = false;
                      addColis = true;
                    });
                  },
                  icon: Icon(Icons.add_card),
                ),
                Text(
                  'Addcolis',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    controller.jumpToPage(2);
                    setState(() {
                      isColis = false;
                      isSetting = true;
                      addColis = false;
                    });
                  },
                  icon: Icon(Icons.settings_accessibility),
                ),
                Text(
                  'Profile',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ]),
        ),
      );
    }
  }

  Widget Encours(String iduser) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: EdgeInsets.all(15),
      child: Column(children: [
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: 'Ex : Xe25efed5',
            prefixIcon: Icon(Icons.search),
            prefixIconColor: Colors.purple,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
            child: Container(
          child: FutureBuilder(
            future: etat2et3(iduser),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                          width: 320,
                          height: 310,
                          padding: new EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onDoubleTap: () {
                              Navigator.pushNamed(context, '/detailsclient',
                                  arguments: {
                                    'idclient': iduser.toString(),
                                    'idcoli': snapshot.data[i]['idcolis'],
                                    'ref': snapshot.data[i]['reference'],
                                    'des': snapshot.data[i]['description'],
                                    'taille': snapshot.data[i]['taille'],
                                    'type': snapshot.data[i]['type'],
                                    'namelivreur': snapshot.data[i]
                                        ['namelivreur'],
                                    'phonelivreur': snapshot.data[i]
                                        ['phonelivreur'],
                                    'prix': snapshot.data[i]['prix'],
                                    'etat': snapshot.data[i]['etat'],
                                    'distance': snapshot.data[i]['distance'],
                                    'msg': messageetat,
                                    //'date': snapshot.data[i]['date'],
                                  });
                            },
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.amber,
                                elevation: 10,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 5,
                                      left: 10,
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.amber,
                                            child: Image.asset(
                                              'assets/images/phone.png',
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              '${snapshot.data[i]['namelivreur']}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 13,
                                      right: 20,
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Icon(Icons.directions),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  '${snapshot.data[i]['distance']} KM',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            children: [
                                              Icon(Icons.price_change_rounded),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  '${snapshot.data[i]['prix']} TND',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        top: 90,
                                        left: 20,
                                        child: Row(
                                          children: [
                                            Text("Ref : ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            Text(
                                                "${snapshot.data[i]['reference']}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)),
                                          ],
                                        )),
                                    if (snapshot.data[i]['etat'] == 'Accepter')
                                      Positioned(
                                          top: 125,
                                          left: 20,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Etat : ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  "${messageetat = 'En attente de livreur...'}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black)),
                                            ],
                                          )),
                                    if (snapshot.data[i]['etat'] == 'En Cours')
                                      Positioned(
                                          top: 125,
                                          left: 20,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Etat : ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  "${messageetat = 'Livreur a commencer la livraison.'}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black)),
                                            ],
                                          )),
                                    Positioned(
                                        top: 180,
                                        left: 20,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Numéro de livreur: ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                "+216 ${snapshot.data[i]['phonelivreur']}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black)),
                                          ],
                                        )),
                                    if (snapshot.data[i]['etat'] == 'En Cours')
                                      new Positioned(
                                          width: 300,
                                          bottom: 15,
                                          left: 10,
                                          child: Column(
                                            children: [
                                              new LinearPercentIndicator(
                                                progressColor: Colors.orange,
                                                width: 300.0,
                                                lineHeight: 14.0,
                                                percent: 0.40,
                                              ),
                                            ],
                                          )),
                                    if (snapshot.data[i]['etat'] == 'Accepter')
                                      new Positioned(
                                          width: 300,
                                          bottom: 15,
                                          left: 10,
                                          child: new LinearPercentIndicator(
                                            progressColor: Colors.red,
                                            width: 300.0,
                                            lineHeight: 14.0,
                                            percent: 0.20,
                                          )),
                                  ],
                                )),
                          ));
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
        )),
      ]),
    )));
  }

  Widget Enattente(String iduser) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: EdgeInsets.all(15),
      child: Column(children: [
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: 'Ex : Xe25efed5',
            prefixIcon: Icon(Icons.search),
            prefixIconColor: Colors.purple,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
            child: Container(
          child: FutureBuilder(
            future: attente(iduser),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int i) {
                      Duration hour24 = Duration(hours: 24);
                      DateTime timecoli =
                          DateTime.parse(snapshot.data[i]['createdat']);
                      DateTime newDateTime = timecoli.add(hour24);
                      Duration difference2 =
                          -DateTime.now().difference(newDateTime);
                      return Container(
                          width: 300,
                          height: 320,
                          padding: new EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onDoubleTap: () {},
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.grey,
                                elevation: 10,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 5,
                                      left: 10,
                                      child: GestureDetector(
                                        onDoubleTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Information de livreur :'),
                                                  content: Container(
                                                    height: 200,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text("Avis : ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black)),
                                                            Text("etoile sur 5",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black)),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text(
                                                                "Photo de profile : ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black)),
                                                            Text("photo",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black)),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text(
                                                                "Position de livreur : ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black)),
                                                            Text("pos",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              child: Image.asset(
                                                'assets/images/phone.png',
                                                width: 40,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                '${snapshot.data[i]['namelivreur']}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 10,
                                        right: 15,
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.alarm,
                                              color: Colors.amber,
                                            ),
                                            if (difference2.inMinutes < 60)
                                              Text(
                                                  " ${difference2.inMinutes}:m",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.amber)),
                                            if (difference2.inMinutes >= 60)
                                              Text(" ${difference2.inHours}:h",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.amber)),
                                            Text("Reste",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.amber))
                                          ],
                                        )),
                                    Positioned(
                                        top: 90,
                                        left: 20,
                                        child: Row(
                                          children: [
                                            Text("Votre prix : ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            Text(
                                                "${snapshot.data[i]['prixclient']} TND",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)),
                                          ],
                                        )),
                                    Positioned(
                                        top: 130,
                                        left: 20,
                                        child: Row(
                                          children: [
                                            Text("Prix Livreur : ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            Text(
                                                "${snapshot.data[i]['prix']} TND",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)),
                                          ],
                                        )),
                                    Positioned(
                                        top: 10,
                                        left: 105,
                                        child: Row(
                                          children: [
                                            Text("Ref : ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            Text(
                                                "${snapshot.data[i]['refcoli']}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)),
                                          ],
                                        )),
                                    Positioned(
                                        top: 170,
                                        left: 20,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Etat : ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("${snapshot.data[i]['etat']}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black)),
                                          ],
                                        )),
                                    Positioned(
                                        width: 140,
                                        bottom: 10,
                                        left: 15,
                                        child: ElevatedButton.icon(
                                            icon: Icon(Icons.crop_sharp),
                                            label: Text('Refusé'),
                                            onPressed: () async {
                                              var idcoli =
                                                  snapshot.data[i]['idcoli'];
                                              var idlivreur =
                                                  snapshot.data[i]['idlivreur'];
                                              await refusecoli(
                                                  idcoli, idlivreur);
                                              if (datarefuse[0]['succes'] ==
                                                  'succes') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    content: Container(
                                                        padding:
                                                            EdgeInsets.all(16),
                                                        height: 90,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "Coli Refusé",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ))),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    content: Container(
                                                        padding:
                                                            EdgeInsets.all(16),
                                                        height: 90,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "Problem obtenu réssayer !",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ))),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                  ),
                                                );
                                              }
                                            })),
                                    Positioned(
                                        width: 140,
                                        bottom: 10,
                                        left: 170,
                                        child: ElevatedButton.icon(
                                            icon: Icon(Icons.check),
                                            label: Text('Accepter'),
                                            onPressed: () async {
                                              var idcoli =
                                                  snapshot.data[i]['idcoli'];
                                              var idlivreur =
                                                  snapshot.data[i]['idlivreur'];
                                              var prixfinal =
                                                  snapshot.data[i]['prix'];
                                              await acceptecoli(
                                                  idcoli, idlivreur, prixfinal);

                                              if (dataAccepte[0]['succes'] ==
                                                  'succes') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    content: Container(
                                                        padding:
                                                            EdgeInsets.all(16),
                                                        height: 90,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "Coli Accepté",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ))),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    content: Container(
                                                        padding:
                                                            EdgeInsets.all(16),
                                                        height: 90,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "Problem obtenu réssayer !",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ))),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                  ),
                                                );
                                              }
                                            }))
                                  ],
                                )),
                          ));
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
        )),
      ]),
    )));
  }

  Widget Rejeter(String iduser) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(children: [
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: 'Ex : Xe25efed5',
            prefixIcon: Icon(Icons.search),
            prefixIconColor: Colors.purple,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: FutureBuilder(
            future: coliEtat(iduser, '4'),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                        width: 300,
                        height: 200,
                        padding: new EdgeInsets.all(10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.red.shade400,
                          elevation: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                contentPadding: EdgeInsets.only(
                                    top: 30, bottom: 0, left: 20),
                                leading: Icon(Icons.collections, size: 40),
                                title: Text('${snapshot.data[i]['type']}',
                                    style: TextStyle(fontSize: 30.0)),
                                subtitle: Text(
                                    '${snapshot.data[i]['description']}',
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                              ButtonBar(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/details',
                                            arguments: {
                                              'ref': snapshot.data[i]
                                                  ['reference'],
                                              'des': snapshot.data[i]
                                                  ['description'],
                                              'taille': snapshot.data[i]
                                                  ['taille'],
                                              'type': snapshot.data[i]['type'],
                                              'prix': snapshot.data[i]['prix'],
                                              'date': snapshot.data[i]['date'],
                                            });
                                      },
                                      child: Text('Details')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
        ),
      ]),
    )));
  }

  Widget Livrer(String iduser) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(children: [
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: 'Ex : Xe25efed5',
            prefixIcon: Icon(Icons.search),
            prefixIconColor: Colors.purple,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: FutureBuilder(
            future: coliEtat(iduser, '5'),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                        width: 300,
                        height: 200,
                        padding: new EdgeInsets.all(10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.green.shade400,
                          elevation: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                contentPadding: EdgeInsets.only(
                                    top: 30, bottom: 0, left: 20),
                                leading: Icon(Icons.collections, size: 40),
                                title: Text('${snapshot.data[i]['type']}',
                                    style: TextStyle(fontSize: 30.0)),
                                subtitle: Text(
                                    '${snapshot.data[i]['description']}',
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                              ButtonBar(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/details',
                                            arguments: {
                                              'ref': snapshot.data[i]
                                                  ['reference'],
                                              'des': snapshot.data[i]
                                                  ['description'],
                                              'taille': snapshot.data[i]
                                                  ['taille'],
                                              'type': snapshot.data[i]['type'],
                                              'prix': snapshot.data[i]['prix'],
                                              'date': snapshot.data[i]['date'],
                                            });
                                      },
                                      child: Text('Details')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
        ),
      ]),
    )));
  }

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep == 0,
            title: Text('Nature de Coli'),
            content: Column(
              children: [
                RadioListTile(
                  title: Text('Alimentaire'),
                  value: 1,
                  groupValue: _selectedValueNature,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      _selectedValueNature = value!;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Electronique'),
                  groupValue: _selectedValueNature,
                  value: 2,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      _selectedValueNature = value!;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Vetement'),
                  groupValue: _selectedValueNature,
                  value: 3,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      _selectedValueNature = value!;
                    });
                  },
                ),
              ],
            )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep == 1,
            title: Text('Type De Coli'),
            content: Column(
              children: [
                RadioListTile(
                  title: Text('Coli Normale'),
                  value: 1,
                  groupValue: _selectedValuetype,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      _selectedValuetype = value!;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Coli Urgente'),
                  value: 2,
                  groupValue: _selectedValuetype,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      _selectedValuetype = value!;
                    });
                  },
                ),
              ],
            )),
        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep == 2,
            title: Text('Taille De Coli'),
            content: Column(
              children: [
                RadioListTile(
                  title: Text('Petite (< 10 kg)'),
                  value: 1,
                  groupValue: _selectedValueTaille,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      _selectedValueTaille = value!;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Moyenne (10 kg vers 30 kg)'),
                  groupValue: _selectedValueTaille,
                  value: 2,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      _selectedValueTaille = value!;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('Grande (plus 30 kg)'),
                  groupValue: _selectedValueTaille,
                  value: 3,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      _selectedValueTaille = value!;
                    });
                  },
                ),
              ],
            )),
        Step(
            state: currentStep > 3 ? StepState.complete : StepState.indexed,
            isActive: currentStep == 3,
            title: Text("Information d'envoyeur"),
            content: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: fullnameE,
                  decoration: InputDecoration(
                      labelText: 'Full name', prefixIcon: Icon(Icons.person)),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailE,
                  decoration: InputDecoration(
                      labelText: 'Email', prefixIcon: Icon(Icons.email)),
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phonenumberE,
                  maxLength: 8,
                  decoration: InputDecoration(
                      labelText: 'Phone number', prefixIcon: Icon(Icons.phone)),
                ),
                TextFormField(
                  controller: placeE,
                  decoration: InputDecoration(
                      labelText: 'Place',
                      suffixIcon: IconButton(
                          onPressed: () async {
                            LatLng location = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Map1(),
                                ));
                            _SendLocation = location;
                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                                    location.latitude, location.longitude);
                            placeE.text =
                                '${placemarks.first.country},${placemarks.first.street}';
                          },
                          icon: Icon(Icons.location_city)),
                      prefixIcon: Icon(Icons.location_city)),
                ),
              ],
            )),
        Step(
            state: currentStep > 4 ? StepState.complete : StepState.indexed,
            isActive: currentStep == 4,
            title: Text("Information de recepteur"),
            content: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: fullnameR,
                  decoration: InputDecoration(
                      labelText: 'Full name', prefixIcon: Icon(Icons.person)),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailR,
                  decoration: InputDecoration(
                      labelText: 'Email', prefixIcon: Icon(Icons.email)),
                ),
                TextFormField(
                  maxLength: 8,
                  keyboardType: TextInputType.phone,
                  controller: phonenumberR,
                  decoration: InputDecoration(
                      labelText: 'Phone number', prefixIcon: Icon(Icons.phone)),
                ),
                TextFormField(
                  controller: placeR,
                  decoration: InputDecoration(
                      labelText: 'Place',
                      suffixIcon: IconButton(
                          onPressed: () async {
                            LatLng location = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Map1(),
                                ));
                            _DestinationLocation = location;
                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                                    location.latitude, location.longitude);
                            placeR.text =
                                '${placemarks.first.country},${placemarks.first.street}';
                          },
                          icon: Icon(Icons.location_city)),
                      prefixIcon: Icon(Icons.location_city)),
                ),
              ],
            )),
        Step(
            state: currentStep > 5 ? StepState.complete : StepState.indexed,
            isActive: currentStep == 5,
            title: Text('Description'),
            content: Column(
              children: [
                TextFormField(
                  controller: description,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Enter your text here...',
                  ),
                )
              ],
            )),
        Step(
            state: currentStep > 6 ? StepState.complete : StepState.indexed,
            isActive: currentStep == 6,
            title: Text('Resume'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nature :\t $_selectedValueNature'),
                Text('Email Envoyeur :\t ${emailE.text}'),
                Text('Email Recepture :\t ${emailR.text}'),
                Text('type :\t $_selectedValuetype'),
                Text('Taille :\t $_selectedValueTaille'),
              ],
            )),
        Step(
          state: currentStep > 7 ? StepState.complete : StepState.indexed,
          isActive: currentStep == 7,
          title: Text('Prix'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Trajet De Coli : ${km.toStringAsFixed(2)} km',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Prix par KM : 0.5 dt',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Prix Base : $prix dt',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Prix Client : $prixclient dt',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ]),
              SizedBox(
                height: 5,
              ),
              Positioned(
                  left: 100,
                  child: Row(
                    children: [
                      ElevatedButton(
                          child: Text(
                            'Confirmer',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await updatePrix(idcoli, prixclient.toString());

                            if (dataprix[0]['succes'] == 'succes') {
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
                                        'Colis Ajouter Avec succes',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ))),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ),
                              );
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
                                            Radius.circular(20)),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "Problem d'insertion Ressayer ! ",
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
                          }),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        child: Text(
                          'Changer Prix',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          price.text = prix;
                          _price = double.parse(prix);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                      Color.fromARGB(249, 252, 231, 45),
                                  title: Text('Changer le prix'),
                                  content: Container(
                                    height: 100,
                                    width: 350,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Max : ${((double.parse(prix) * 20 / 100) + double.parse(prix)).round()} dt',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Min : ${(double.parse(prix) - (double.parse(prix) * 20 / 100)).round()} dt',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        TextFormField(
                                          controller: price,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            prefixIcon: IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {
                                                  var percentage =
                                                      (double.parse(prix) *
                                                              20) /
                                                          100;
                                                  var max = double.parse(prix) +
                                                      percentage;
                                                  if (double.parse(
                                                          price.text) ==
                                                      max.round()) {
                                                    setState(() {});
                                                    return null;
                                                  } else {
                                                    setState(() {
                                                      _price = _price + 1;
                                                      price.text = '$_price';
                                                    });
                                                    setState(() {});
                                                  }
                                                }),
                                            suffixIcon: IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () {
                                                var percentage =
                                                    (double.parse(prix) * 20) /
                                                        100;
                                                var min = double.parse(prix) -
                                                    percentage;
                                                print(min.round());
                                                if (double.parse(price.text) ==
                                                    min.round()) {
                                                  setState(() {});
                                                  return null;
                                                } else {
                                                  setState(() {
                                                    _price = _price - 1;
                                                    price.text = '$_price';
                                                  });
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Confirmer'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          prixclient = price.text;
                                        });
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ];
}
