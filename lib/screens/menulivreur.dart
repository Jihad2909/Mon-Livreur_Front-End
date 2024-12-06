import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';

class MenuLivreur extends StatefulWidget {
  const MenuLivreur({super.key});

  @override
  State<MenuLivreur> createState() => _MenuState();
}

class _MenuState extends State<MenuLivreur> {
  TextEditingController price = TextEditingController();

  List data = [];
  List dataenattente = [];
  List negos_data = [];
  List datauser = [];
  List data2 = [];
  List etatcoli = [];
  int prix = 0;
  String prixlivreur = '0';
  double soldebloque = 0.0;
  bool? ok;

  // String iduser = '31';
  bool isobpassword = false;
  bool t = true;

  final controller = PageController();
  bool isColis = false;
  bool isSetting = false;
  bool addColis = false;
  Map datacoli = {};
  String messageetat = '';

  //Profile livreur
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
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('An error occurred'),
              content: Text(
                  'Probleme Au niveau de Connexion avec la base de donnee'),
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

  Future etat2et3(idlivreur) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/getColiEtat2et3Livreur'),
      body: {
        'idlivreur': idlivreur.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      return ok;
    }
  }

  Future attente(idlivreur) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/EnattenteLivreur'),
      body: {
        'idlivreur': idlivreur.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      return ok;
    }
  }

  Future alertEmplois(idlivreur) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/alertEmplois'),
      body: {
        'idlivreur': idlivreur.toString(),
      },
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      return ok;
    }
  }

  @override
  Widget build(BuildContext context) {
    /*final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String iduser = args['iduser'];*/
    var iduser = "2";
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
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: alertEmploi(iduser.toString()),
              ),
            ),
            Visibility(
              visible: true,
              child: Container(
                color: Colors.grey,
                padding: EdgeInsets.only(left: 15, top: 20, right: 15),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: [
                      Container(
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/portfeuille',
                                    arguments: {
                                      'idlivreur': iduser.toString(),
                                    });
                              },
                              icon: Icon(
                                Icons.wallet,
                                color: Colors.amber,
                                size: 35,
                              ))),
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
                                    arguments: {'iduser': iduser.toString()});
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
                  icon: Icon(Icons.add_box),
                ),
                Text(
                  'AlertEmplois',
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
      body: Column(children: [
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
            future: etat2et3(iduser),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                          width: double.infinity,
                          height: 200,
                          child: GestureDetector(
                            onDoubleTap: () {
                              if (snapshot.data[i]['etat'] == 'Accepter') {
                                messageetat = 'En attente de commencemant';
                              } else if (snapshot.data[i]['etat'] ==
                                  'En cours') {
                                messageetat = 'Vous avez commencez cette coli';
                              }
                              Navigator.pushNamed(context, '/detailslivreur',
                                  arguments: {
                                    'idlivreur': iduser.toString(),
                                    'idcoli': snapshot.data[i]['idcolis'],
                                    'ref': snapshot.data[i]['reference'],
                                    'des': snapshot.data[i]['description'],
                                    'taille': snapshot.data[i]['taille'],
                                    'type': snapshot.data[i]['type'],
                                    'nameclient': snapshot.data[i]
                                        ['nameclient'],
                                    'idclient': snapshot.data[i]['idclient'],
                                    'prix': snapshot.data[i]['prix'],
                                    'etat': snapshot.data[i]['etat'],
                                    'distance': snapshot.data[i]['distance'],
                                    'numE': snapshot.data[i]['numE'],
                                    'numR': snapshot.data[i]['numR'],
                                    'adR': snapshot.data[i]['adR'],
                                    'adE': snapshot.data[i]['adE'],
                                    'msg': messageetat,

                                    //'date': snapshot.data[i]['date'],
                                  });
                            },
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.green,
                                elevation: 10,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 5,
                                      left: 5,
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.green,
                                            child: Image.asset(
                                              'assets/images/phone.png',
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              '${snapshot.data[i]['nameclient']}',
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
                                      right: 50,
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
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Adresse Rammasage :',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data[i]['nameE'],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        )),
                                    Positioned(
                                        top: 140,
                                        left: 20,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Adresse Distinateur :',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data[i]['nameR'],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        )),
                                    if (snapshot.data[i]['etat'] == 'Accepter')
                                      new Positioned(
                                          width: 320,
                                          top: 200,
                                          left: 5,
                                          child: new LinearPercentIndicator(
                                            progressColor: Colors.red,
                                            width: 320,
                                            lineHeight: 14.0,
                                            percent: 0.20,
                                          )),
                                    if (snapshot.data[i]['etat'] == 'En Cours')
                                      new Positioned(
                                          width: 320,
                                          top: 200,
                                          left: 5,
                                          child: new LinearPercentIndicator(
                                            progressColor: Colors.amber,
                                            width: 300.0,
                                            lineHeight: 14.0,
                                            percent: 0.40,
                                          )),
                                    if (snapshot.data[i]['etat'] == 'Accepter')
                                      Positioned(
                                          top: 227,
                                          width: 333,
                                          child: TextButton.icon(
                                              onPressed: () async {
                                                Navigator.pushNamed(
                                                    context, '/mapliteraire',
                                                    arguments: {
                                                      'idcoli': snapshot.data[i]
                                                          ['idcolis'],
                                                      'idlivreur': snapshot
                                                          .data[i]['idlivreur'],
                                                      'idclient': snapshot
                                                          .data[i]['idclient'],
                                                    });
                                                var idcoli = snapshot.data[i]
                                                        ['idcolis']
                                                    .toString();
                                                var idlivreur = snapshot.data[i]
                                                        ['idlivreur']
                                                    .toString();

                                                await updateLivreurEtat(
                                                    idcoli, idlivreur, '3');
                                              },
                                              icon: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.red),
                                              label: Text(
                                                'Commencer',
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 18,
                                                  color: Colors.red,
                                                ),
                                              ))),
                                    if (snapshot.data[i]['etat'] == 'En Cours')
                                      Positioned(
                                          top: 227,
                                          width: 333,
                                          child: TextButton.icon(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/mapliteraire',
                                                    arguments: {
                                                      'idcoli': snapshot.data[i]
                                                          ['idcolis'],
                                                      'idlivreur': snapshot
                                                          .data[i]['idlivreur'],
                                                      'idclient': snapshot
                                                          .data[i]['idclient'],
                                                    });
                                              },
                                              icon: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.amber),
                                              label: Text(
                                                'Reprendre',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.amber,
                                                ),
                                              ))),
                                  ],
                                )),
                          ));
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
        ),
      ]),
    );
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
                      return Container(
                          width: 300,
                          height: 250,
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
                                      left: 5,
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
                                              '${snapshot.data[i]['nameclient']}',
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
                                        top: 13,
                                        left: 100,
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
                                        top: 90,
                                        left: 14,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Etat : ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            Text("${snapshot.data[i]['etat']}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black)),
                                          ],
                                        )),
                                    Positioned(
                                        top: 150,
                                        left: 14,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Numéro Client : ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            Text("${snapshot.data[i]['phone']}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black)),
                                          ],
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

  Widget alertEmploi(String iduser) {
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
            future: alertEmplois(iduser),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int i) {
                      final solde = snapshot.data[i]['solde'];
                      final prixcoliss = snapshot.data[i]['prix'];
                      soldebloque = (prixcoliss * 10) / 100;
                      if (solde >= soldebloque) {
                        ok = true;
                      } else {
                        ok = false;
                      }
                      return Container(
                          width: 300,
                          height: 330,
                          padding: new EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onDoubleTap: () {},
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
                                      left: 5,
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
                                              '${snapshot.data[i]['clientname']}',
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
                                    Positioned(
                                        top: 130,
                                        left: 20,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Adresse Ramassage : ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("${snapshot.data[i]['adR']}",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black)),
                                          ],
                                        )),
                                    Positioned(
                                        top: 190,
                                        left: 20,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Adresse Distinateur : ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("${snapshot.data[i]['adE']}",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black)),
                                          ],
                                        )),
                                    if (ok == true)
                                      Positioned(
                                          width: 333,
                                          bottom: -2,
                                          left: 0,
                                          child: TextButton.icon(
                                              icon: Icon(
                                                Icons.price_change,
                                                color: Colors.red,
                                              ),
                                              label: Text(
                                                'Negocié prix',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/negocie',
                                                    arguments: {
                                                      'idlivreur':
                                                          iduser.toString(),
                                                      'idcolis': snapshot
                                                          .data[i]['idcolis'],
                                                      'prixclient': snapshot
                                                          .data[i]['prix'],
                                                      'idclient': snapshot
                                                          .data[i]['idclient'],
                                                      'soldeb': soldebloque,
                                                    });
                                              })),
                                    if (ok == false)
                                      Positioned(
                                          width: 333,
                                          bottom: 10,
                                          left: 20,
                                          child: Text(
                                            'Vous devez avoir minmum ${soldebloque}DT\ndans votre solde pour negocié.',
                                            style: TextStyle(
                                                fontSize: 19,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ))
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
                          color: Color.fromARGB(255, 241, 56, 10),
                          elevation: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                contentPadding: EdgeInsets.only(
                                    top: 30, bottom: 0, left: 20),
                                leading: Icon(Icons.collections, size: 40),
                                title: Text('${snapshot.data[i]['reference']}',
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
                                              'idlivreur': iduser.toString(),
                                              'idcolis': snapshot.data[i]
                                                  ['idcolis'],
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
        )),
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
}
