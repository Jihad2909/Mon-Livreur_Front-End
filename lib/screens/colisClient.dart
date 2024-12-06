import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

class ColisClient extends StatefulWidget {
  final idclient;
  const ColisClient({super.key, required this.idclient});

  @override
  State<ColisClient> createState() => _ColisLivreurState(idclient);
}

class _ColisLivreurState extends State<ColisClient> {
  int idclient;
  _ColisLivreurState(this.idclient);

  List dataAccepte = [];
  List datarefuse = [];
  List dataAvis = [];
  List datarepub = [];
  List datasupp = [];
  String search2Et3 = '';
  String searchPublie = '';
  String searchLivrer = '';
  String searchRejeter = '';
  bool shownot = false;
  int countNot = 0;

  double rate = 0.0;
  double raterejeter = 0.0;
  TextEditingController commentaire = TextEditingController();

  Future publiee(idclient, search) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/publieClient'),
      body: {
        'idclient': idclient.toString(),
        'search': search.toString(),
      },
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      return ok;
    }
  }

  Future etat2et3(idclient, search) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/getColiEtat2et3Client'),
      body: {
        'idclient': idclient.toString(),
        'search': search.toString(),
      },
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

  Future publie(idclient, search) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/publieClient'),
      body: {
        'idclient': idclient.toString(),
        'search': search.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      return ok;
    }
  }

  Future rejeter(idclient, search) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/getColirejeterClient'),
      body: {
        'iduser': idclient.toString(),
        'search': search.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      return ok;
    }
  }

  Future livrer(idclient, search) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/getColiLivrerClient'),
      body: {
        'iduser': idclient.toString(),
        'search': search.toString(),
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

  Future republie(idcoli) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/republierClient'),
      body: {
        'idcoli': idcoli.toString(),
      },
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        datarepub.add(ok);
      });
    }
  }

  Future supprimer(idcoli) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/supprimerColiClient'),
      body: {
        'idcoli': idcoli.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        datasupp.add(ok);
      });
    }
  }

  Future avis(idcoli, idlivreur, idclient, message, avis) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/donnerAvis'),
      body: {
        'idcoli': idcoli.toString(),
        'idlivreur': idlivreur.toString(),
        'idclient': idclient.toString(),
        'message': message.toString(),
        'avis': avis.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        dataAvis.add(ok);
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

  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((value) => print(value));
    FirebaseMessaging.onMessage.listen((event) {
      if (this.mounted) {
        setState(() {
          countNot++;
          shownot = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Badge(
              label: Text(
                '$countNot',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              isLabelVisible: shownot,
              smallSize: 10,
              largeSize: 23,
              alignment: AlignmentDirectional.topCenter,
              padding: EdgeInsets.all(5),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    countNot = 0;
                    shownot = false;
                  });
                  Navigator.pushNamed(context, '/notficationn', arguments: {
                    'idclient': idclient,
                  });
                },
                icon: Icon(Icons.notifications),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          title: Center(
            child: Text('       Colis',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.run_circle,
                    color: Colors.amber,
                  ),
                  text: 'En cours',
                ),
                Tab(
                  icon: Icon(
                    Icons.pause_circle,
                    color: Colors.grey,
                  ),
                  text: 'En attente',
                ),
                Tab(
                  icon: Icon(
                    Icons.download,
                    color: Colors.purple,
                  ),
                  text: 'Publié',
                ),
                Tab(
                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                  text: 'Rejeté',
                ),
                Tab(
                  icon: Icon(
                    Icons.check_box,
                    color: Colors.green,
                  ),
                  text: 'Livré',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Encours(),
                  Enattente(),
                  Publie(),
                  Rejeter(),
                  Livrer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //iduser
  Widget Encours() {
    return Scaffold(
        body: Column(
      children: [
        Container(
          padding: EdgeInsets.all(7),
          child: TextField(
            onChanged: (value) {
              setState(() {
                search2Et3 = value;
              });
            },
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
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(3),
            color: Colors.white,
            child: FutureBuilder(
              future: etat2et3(idclient, search2Et3),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 4, left: 4, right: 4, bottom: 40),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(blurRadius: 6, offset: Offset(1, 1))
                              ]),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    top: 15, left: 12, right: 12, bottom: 22),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(left: 0),
                                        width: 110,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 25,
                                              backgroundImage: AssetImage(
                                                'assets/images/livreurmo.jpg',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${snapshot.data[i]['namelivreur']}'
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 70, 68, 68),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: 120,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Ref :',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 46, 18, 92),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            '${snapshot.data[i]['reference']}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 2, bottom: 2),
                                padding: EdgeInsets.only(
                                    top: 10, left: 5, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Prix finale :',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 46, 18, 92),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${snapshot.data[i]['prix']} DT.',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 119, 108, 108),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    top: 10, left: 5, bottom: 10),
                                margin: EdgeInsets.only(bottom: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date de Debut :',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 46, 18, 92),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Le ${snapshot.data[i]['date']} A ${snapshot.data[i]['time']}.',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 143, 41, 41),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    top: 10, left: 5, bottom: 10),
                                margin: EdgeInsets.only(bottom: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Distance de Trajet :',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 46, 18, 92),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${snapshot.data[i]['distance']} KM.',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 119, 108, 108),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    top: 10, left: 5, bottom: 10),
                                margin: EdgeInsets.only(bottom: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Etat :',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(255, 4, 2, 65),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    if (snapshot.data[i]['etat'] == 'Accepter')
                                      Text(
                                        'Accepté, en attente de commancement de livreur.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 119, 108, 108),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    if (snapshot.data[i]['etat'] == 'En Cours')
                                      Text(
                                        'Livreur a commencé cette coli...',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 119, 108, 108),
                                            fontWeight: FontWeight.w500),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.black),
                                ),
                                width: double.infinity,
                                margin:
                                    EdgeInsets.only(top: 14, left: 3, right: 3),
                                child: MaterialButton(
                                  height: 45,
                                  color: Color.fromARGB(255, 235, 233, 233),
                                  child: Text(
                                    "Plus d'information",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/detailsclient',
                                      arguments: {
                                        'idclient': idclient.toString(),
                                        'idlivreur': snapshot.data[i]
                                            ['idlivreur'],
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
                                        'distance': snapshot.data[i]
                                            ['distance'],
                                        'date': snapshot.data[i]['date'],
                                        'adR': snapshot.data[i]['adR'],
                                        'adE': snapshot.data[i]['adE'],
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ],
    ));
  }

  Widget Enattente() {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 3, right: 3),
              color: Colors.white,
              child: FutureBuilder(
                future: attente(idclient),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        Duration hour24 = Duration(hours: 24);
                        DateTime timecoli =
                            DateTime.parse(snapshot.data[i]['createdat']);
                        DateTime newDateTime = timecoli.add(hour24);
                        Duration difference2 =
                            -DateTime.now().difference(newDateTime);
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 4, left: 4, right: 4, bottom: 40),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 210, 210, 206),
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 6,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  color: Color.fromARGB(31, 218, 216, 216),
                                  padding: EdgeInsets.only(
                                      top: 15, left: 12, right: 12, bottom: 22),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(left: 0),
                                        width: 110,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (snapshot.data[i]
                                                            ['message'] ==
                                                        null &&
                                                    snapshot.data[i]['avis'] ==
                                                        null) {
                                                  Navigator.pushNamed(context,
                                                      '/livreurinfonull',
                                                      arguments: {
                                                        'namelivreur':
                                                            snapshot.data[i]
                                                                ['namelivreur'],
                                                      });
                                                } else {
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/livreurinfo',
                                                    arguments: {
                                                      'namelivreur':
                                                          snapshot.data[i]
                                                              ['namelivreur'],
                                                      'nameclient':
                                                          snapshot.data[i]
                                                              ['clientavis'],
                                                      'message': snapshot
                                                          .data[i]['message'],
                                                      'avis': snapshot.data[i]
                                                          ['nbavis'],
                                                      'nbavis': snapshot.data[i]
                                                          ['nbreClientavis'],
                                                      'colislivrer': snapshot
                                                          .data[i]['nblivrer'],
                                                      'colisrejeter': snapshot
                                                          .data[i]['nbrejeter'],
                                                    },
                                                  );
                                                }
                                              },
                                              child: CircleAvatar(
                                                maxRadius: 25,
                                                backgroundImage: AssetImage(
                                                  'assets/images/livreurmo.jpg',
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${snapshot.data[i]['namelivreur']}'
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 70, 68, 68),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        width: 200,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Ref :',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 46, 18, 92),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  '${snapshot.data[i]['refcoli']}',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Icon(
                                                  Icons.alarm,
                                                  color: Colors.red,
                                                  size: 50,
                                                ),
                                                if (difference2.inMinutes < 60)
                                                  Text(
                                                    '${difference2.inMinutes}m',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                                if (difference2.inMinutes >= 60)
                                                  Text(
                                                    '${difference2.inHours}h',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color.fromARGB(31, 218, 216, 216),
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 2, bottom: 2),
                                  padding: EdgeInsets.only(
                                      top: 10, left: 5, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Votre prix :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 46, 18, 92),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${snapshot.data[i]['prixclient']} DT.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 119, 108, 108),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color.fromARGB(31, 218, 216, 216),
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      top: 10, left: 5, bottom: 10),
                                  margin: EdgeInsets.only(bottom: 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Livreur prix :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 4, 2, 65),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${snapshot.data[i]['prix']} DT.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 119, 108, 108),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color.fromARGB(31, 218, 216, 216),
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      top: 10, left: 5, bottom: 10),
                                  margin: EdgeInsets.only(bottom: 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Etat :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 46, 18, 92),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${snapshot.data[i]['etat']}.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 119, 108, 108),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      top: 20, left: 3, right: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: MaterialButton(
                                          height: 45,
                                          color: Color.fromARGB(
                                              255, 254, 254, 254),
                                          child: Text(
                                            "Annuler",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () async {
                                            var idcoli =
                                                snapshot.data[i]['idcoli'];
                                            var idlivreur =
                                                snapshot.data[i]['idlivreur'];
                                            await refusecoli(idcoli, idlivreur);
                                            if (datarefuse[0]['succes'] ==
                                                'succes') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content: Container(
                                                    padding: EdgeInsets.all(16),
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Colis annulé avec succé.",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  elevation: 0,
                                                ),
                                              );
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: MaterialButton(
                                          height: 45,
                                          color: Color.fromARGB(
                                              255, 187, 188, 187),
                                          child: Text(
                                            "Accepter",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () async {
                                            var idcoli =
                                                snapshot.data[i]['idcoli'];
                                            var idlivreur =
                                                snapshot.data[i]['idlivreur'];
                                            var pf = snapshot.data[i]['prix'];
                                            await acceptecoli(
                                                idcoli, idlivreur, pf);
                                            if (dataAccepte[0]['succes'] ==
                                                'succes') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content: Container(
                                                    padding: EdgeInsets.all(16),
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Colis Accepté avec succé.",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  elevation: 0,
                                                ),
                                              );
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Publie() {
    return Scaffold(
        body: Column(
      children: [
        Container(
          padding: EdgeInsets.all(7),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchPublie = value;
              });
            },
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
        ),
        Expanded(
          child: Container(
              margin: EdgeInsets.all(3),
              color: Colors.white,
              child: FutureBuilder(
                future: publie(idclient, searchPublie),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 4, left: 4, right: 4, bottom: 40),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(blurRadius: 6, offset: Offset(1, 1))
                                ]),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Ref :',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 46, 18, 92),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            '${snapshot.data[i]['reference']}',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 81, 79, 79),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.price_change,
                                            color: Colors.purple,
                                            size: 30,
                                          ),
                                          Text(
                                            '${snapshot.data[i]['prix']}DT.',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (snapshot.data[i]['etat'] == 0)
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(top: 2, bottom: 2),
                                    padding: EdgeInsets.only(
                                        top: 10, left: 5, bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Etat :',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 46, 18, 92),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        if (snapshot.data[i]['etat'] == 0)
                                          Text(
                                            'Ce coli a passé 24h sans proposition.',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 159, 24, 24),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 2, bottom: 2),
                                  padding: EdgeInsets.only(
                                      top: 10, left: 5, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Taille :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 46, 18, 92),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${snapshot.data[i]['taille']}'
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 119, 108, 108),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      top: 10, left: 5, bottom: 10),
                                  margin: EdgeInsets.only(bottom: 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date et heure de debut :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 4, 2, 65),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'le : ${snapshot.data[i]['date']} A : ${snapshot.data[i]['time']}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 119, 108, 108),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      top: 10, left: 5, bottom: 10),
                                  margin: EdgeInsets.only(bottom: 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Distance de Trajet :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 46, 18, 92),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${snapshot.data[i]['distance']} KM.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 119, 108, 108),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                if (snapshot.data[i]['etat'] == 1)
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: Colors.black)),
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        top: 14, left: 3, right: 3),
                                    child: MaterialButton(
                                      color: Colors.white,
                                      height: 45,
                                      child: Text(
                                        'Supprimer',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () async {
                                        var idcoli =
                                            snapshot.data[i]['idcolis'];
                                        await supprimer(idcoli);
                                      },
                                    ),
                                  ),
                                if (snapshot.data[i]['etat'] == 0)
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: Colors.black)),
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        top: 14, left: 3, right: 3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: MaterialButton(
                                            color: Colors.white,
                                            height: 45,
                                            child: Text(
                                              'Supprimer',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () async {
                                              var idcoli =
                                                  snapshot.data[i]['idcolis'];
                                              await supprimer(idcoli);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(width: 2),
                                              ),
                                            ),
                                            child: MaterialButton(
                                              color: Color.fromARGB(
                                                  255, 237, 237, 238),
                                              height: 45,
                                              child: Text(
                                                'Republier',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: () async {
                                                var idcoli =
                                                    snapshot.data[i]['idcolis'];
                                                await republie(idcoli);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
        ),
      ],
    ));
  }

  Widget Rejeter() {
    return Scaffold(
        body: Column(
      children: [
        Container(
          padding: EdgeInsets.all(7),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchRejeter = value;
              });
            },
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
        ),
        Expanded(
          child: Container(
              margin: EdgeInsets.all(3),
              color: Colors.white,
              child: FutureBuilder(
                future: rejeter(idclient, searchRejeter),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 4, left: 4, right: 4, bottom: 40),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 236, 93, 105),
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(blurRadius: 6, offset: Offset(1, 1))
                                ]),
                            child: Column(
                              children: [
                                Container(
                                  color: Color.fromARGB(31, 218, 216, 216),
                                  padding: EdgeInsets.only(
                                      top: 15, left: 12, right: 12, bottom: 22),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          alignment: Alignment.topLeft,
                                          padding: EdgeInsets.only(left: 0),
                                          width: 110,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                maxRadius: 25,
                                                backgroundImage: AssetImage(
                                                  'assets/images/livreurmo.jpg',
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${snapshot.data[i]['livreurname']}'
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 70, 68, 68),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          )),
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              'Ref :',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 46, 18, 92),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              '${snapshot.data[i]['reference']}',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 97, 89, 89),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color.fromARGB(31, 218, 216, 216),
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 2, bottom: 2),
                                  padding: EdgeInsets.only(
                                      top: 10, left: 5, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pourquoi ? :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 46, 18, 92),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${snapshot.data[i]['messagerejeter']}.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 88, 86, 86),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color.fromARGB(31, 218, 216, 216),
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 2, bottom: 2),
                                  padding: EdgeInsets.only(
                                      top: 10, left: 5, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rejeter A :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 46, 18, 92),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${snapshot.data[i]['daterejeter']}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 88, 86, 86),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                if (snapshot.data[i]['message'] != null)
                                  Container(
                                    color: Color.fromARGB(31, 218, 216, 216),
                                    width: double.infinity,
                                    padding: EdgeInsets.only(
                                        top: 10, left: 5, bottom: 10),
                                    margin: EdgeInsets.only(bottom: 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Vos Commentaire :',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color:
                                                  Color.fromARGB(255, 4, 2, 65),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${snapshot.data[i]['message']}.',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 88, 84, 84),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (snapshot.data[i]['etoile'] != null)
                                  Container(
                                    color: Color.fromARGB(31, 218, 216, 216),
                                    width: double.infinity,
                                    padding: EdgeInsets.only(
                                        top: 10, left: 5, bottom: 10),
                                    margin: EdgeInsets.only(bottom: 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Vos Avis :',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 46, 18, 92),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Center(
                                          child: RatingBarIndicator(
                                            rating: snapshot.data[i]['etoile']
                                                .toDouble(),
                                            itemCount: 5,
                                            itemBuilder: (context, index) {
                                              return const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (snapshot.data[i]['message'] == null &&
                                    snapshot.data[i]['etoile'] == null)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.black,
                                      ),
                                    ),
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        top: 14, left: 3, right: 3, bottom: 5),
                                    child: Center(
                                      child: RatingBar.builder(
                                        initialRating: 1,
                                        itemCount: 5,
                                        itemBuilder: (context, index) {
                                          return const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          );
                                        },
                                        onRatingUpdate: (value) {
                                          setState(() {
                                            raterejeter = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                if (snapshot.data[i]['message'] == null &&
                                    snapshot.data[i]['etoile'] == null)
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2),
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: commentaire,
                                          decoration: InputDecoration(
                                            hintText: 'Donner un commentaire',
                                          ),
                                        ),
                                        MaterialButton(
                                          color: Color.fromARGB(
                                              255, 218, 214, 214),
                                          child: Text('Envoyer'),
                                          onPressed: () async {
                                            if (commentaire.text.isEmpty) {
                                              return null;
                                            } else {
                                              var idcoli =
                                                  snapshot.data[i]['idcolis'];
                                              var idlivreur =
                                                  snapshot.data[i]['idlivreur'];
                                              var idclient =
                                                  snapshot.data[i]['idclient'];
                                              await avis(
                                                  idcoli,
                                                  idlivreur,
                                                  idclient,
                                                  commentaire.text,
                                                  raterejeter);

                                              if (dataAvis[0]['succes'] ==
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
                                                          "Votre Avis est Envoyer",
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
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
        ),
      ],
    ));
  }

  Widget Livrer() {
    return Scaffold(
        body: Column(
      children: [
        Container(
          padding: EdgeInsets.all(7),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchLivrer = value;
              });
            },
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
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(3),
            color: Colors.white,
            child: FutureBuilder(
              future: livrer(idclient, searchLivrer),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 4, left: 4, right: 4, bottom: 40),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 163, 244, 105),
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(blurRadius: 6, offset: Offset(1, 1))
                              ]),
                          child: Column(
                            children: [
                              Container(
                                color: Color.fromARGB(31, 218, 216, 216),
                                padding: EdgeInsets.only(
                                    top: 15, left: 12, right: 12, bottom: 22),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(left: 0),
                                        width: 110,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 25,
                                              backgroundImage: AssetImage(
                                                'assets/images/livreurmo.jpg',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${snapshot.data[i]['livreurname']}'
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 70, 68, 68),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: 120,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Ref :',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 46, 18, 92),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            '${snapshot.data[i]['reference']}',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 104, 101, 101),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 5, bottom: 10, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Livrer A :',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 46, 18, 92),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${snapshot.data[i]['dateLivrer']}',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 104, 102, 102),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Color.fromARGB(31, 218, 216, 216),
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 2, bottom: 2),
                                padding: EdgeInsets.only(
                                    top: 10, left: 5, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (snapshot.data[i]['message'] != null)
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Vos commentaire :',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 46, 18, 92),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${snapshot.data[i]['message']}.',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 119, 108, 108),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (snapshot.data[i]['etoile'] != null)
                                Container(
                                  color: Color.fromARGB(31, 218, 216, 216),
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      top: 10, left: 5, bottom: 10),
                                  margin: EdgeInsets.only(bottom: 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Vos Avis :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 4, 2, 65),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: RatingBarIndicator(
                                          rating: snapshot.data[i]['etoile']
                                              .toDouble(),
                                          itemCount: 5,
                                          itemBuilder: (context, index) {
                                            return const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (snapshot.data[i]['message'] == null &&
                                  snapshot.data[i]['etoile'] == null)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      top: 14, left: 3, right: 3, bottom: 5),
                                  child: Center(
                                    child: RatingBar.builder(
                                      initialRating: 1,
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        );
                                      },
                                      onRatingUpdate: (value) {
                                        setState(() {
                                          rate = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              if (snapshot.data[i]['message'] == null &&
                                  snapshot.data[i]['etoile'] == null)
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2),
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: commentaire,
                                        decoration: InputDecoration(
                                          hintText: 'Donner un commentaire',
                                        ),
                                      ),
                                      MaterialButton(
                                        color:
                                            Color.fromARGB(255, 218, 214, 214),
                                        child: Text('Envoyer'),
                                        onPressed: () async {
                                          if (commentaire.text.isEmpty) {
                                            return null;
                                          } else {
                                            var idcoli =
                                                snapshot.data[i]['idcolis'];
                                            var idlivreur =
                                                snapshot.data[i]['idlivreur'];
                                            var idclient =
                                                snapshot.data[i]['idclient'];
                                            await avis(
                                                idcoli,
                                                idlivreur,
                                                idclient,
                                                commentaire.text,
                                                rate);

                                            if (dataAvis[0]['succes'] ==
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
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                        "Votre Avis est Envoyer",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ))),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  elevation: 0,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ],
    ));
  }
}
