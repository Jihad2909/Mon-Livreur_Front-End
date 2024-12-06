import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class ColisLivreur extends StatefulWidget {
  final iduser;
  const ColisLivreur({super.key, required this.iduser});

  @override
  // ignore: no_logic_in_create_state
  State<ColisLivreur> createState() => _ColisLivreurState(iduser);
}

class _ColisLivreurState extends State<ColisLivreur> {
  int iduser;
  _ColisLivreurState(this.iduser);

  List etatcoli = [];
  List annuler = [];
  String search2Et3 = '';
  String searchPublie = '';
  String searchLivrer = '';
  String searchRejeter = '';
  bool shownot = false;
  int countNot = 0;
  String tokendevice = '';

  Future etat2et3(idlivreur, search) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/getColiEtat2et3Livreur'),
      body: {
        'idlivreur': idlivreur.toString(),
        'search': search.toString(),
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

  Future rejeter(idlivreur, search) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/getColirejeterLivreur'),
      body: {
        'iduser': idlivreur.toString(),
        'search': search.toString(),
      },
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      return ok;
    }
  }

  Future livrer(idlivreur, search) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/getColiLivrerLivreur'),
      body: {
        'iduser': idlivreur.toString(),
        'search': search.toString(),
      },
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

  Future annulerEnattente(
    idcoli,
    idlivreur,
  ) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/EnattenteLivreurAnnuler'),
      body: {
        'idcoli': idcoli.toString(),
        'idlivreur': idlivreur.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        annuler.add(ok);
      });
    }
  }

  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((value) => tokendevice = value!);
    FirebaseMessaging.onMessage.listen((event) {
      if (tokendevice == tokendevice) {
        if (this.mounted) {
          setState(() {
            countNot++;
            shownot = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
                  Navigator.pushNamed(context, '/notficationLivreur',
                      arguments: {
                        'idlivreur': iduser,
                      });
                },
                icon: Icon(Icons.notifications),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          title: Center(
            child: Text('Colis',
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
                  Encours(iduser.toString()),
                  Enattente(iduser.toString()),
                  Rejeter(iduser.toString()),
                  Livrer(iduser.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //iduser
  Widget Encours(iduser) {
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
                future: etat2et3(iduser, search2Et3),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        DateTime now = DateTime.now();
                        DateTime datenow = DateTime(
                            now.year, now.month, now.day, now.hour, now.minute);
                        String coli =
                            '${snapshot.data[i]['date']} ${snapshot.data[i]['time']}';
                        DateTime coliDAte = DateTime.parse(coli);

                        bool testColiDate = datenow.isAfter(coliDAte);

                        print('$testColiDate');

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
                                                  'assets/images/clientpic.jpg',
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${snapshot.data[i]['nameclient']}'
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
                                                Color.fromARGB(255, 4, 2, 65),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      if (snapshot.data[i]['etat'] ==
                                          'Accepter')
                                        Text(
                                          'Le client a accepté votre demande.',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 119, 108, 108),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      if (snapshot.data[i]['etat'] ==
                                          'En Cours')
                                        Text(
                                          'Ce coli est en cours... ',
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
                                  margin: EdgeInsets.only(top: 2, bottom: 2),
                                  padding: EdgeInsets.only(
                                      top: 10, left: 5, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date et Heure de debut:',
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
                                        'Le : ${snapshot.data[i]['date']}  A : ${snapshot.data[i]['time']}.',
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
                                  margin: EdgeInsets.only(top: 2, bottom: 2),
                                  padding: EdgeInsets.only(
                                      top: 10, left: 5, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                if (testColiDate == false)
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.black),
                                    ),
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        top: 14, left: 3, right: 3),
                                    child: MaterialButton(
                                      height: 45,
                                      color: Colors.amber,
                                      child: Text(
                                        "Ce coli sera disponible le : ${snapshot.data[i]['date']} A ${snapshot.data[i]['time']}.",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 129, 44, 38)),
                                      ),
                                      onPressed: null,
                                    ),
                                  ),
                                if (snapshot.data[i]['etat'] == 'Accepter' &&
                                    testColiDate == true)
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.black),
                                    ),
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        top: 14, left: 3, right: 3),
                                    child: MaterialButton(
                                      height: 45,
                                      color: Color.fromARGB(255, 225, 224, 222),
                                      child: Text(
                                        "Commencer",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.pushNamed(
                                            context, '/mapliteraire',
                                            arguments: {
                                              'idcoli': snapshot.data[i]
                                                  ['idcolis'],
                                              'idlivreur': snapshot.data[i]
                                                  ['idlivreur'],
                                              'idclient': snapshot.data[i]
                                                  ['idclient'],
                                            });
                                        var idcoli = snapshot.data[i]['idcolis']
                                            .toString();
                                        var idlivreur = snapshot.data[i]
                                                ['idlivreur']
                                            .toString();

                                        await updateLivreurEtat(
                                            idcoli, idlivreur, '3');
                                      },
                                    ),
                                  ),
                                if (snapshot.data[i]['etat'] == 'En Cours' &&
                                    testColiDate == true)
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.black),
                                    ),
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        top: 14, left: 3, right: 3),
                                    child: MaterialButton(
                                      height: 45,
                                      color: Colors.grey,
                                      child: Text(
                                        "Reprendre",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/mapliteraire',
                                          arguments: {
                                            'idcoli': snapshot.data[i]
                                                ['idcolis'],
                                            'idlivreur': snapshot.data[i]
                                                ['idlivreur'],
                                            'idclient': snapshot.data[i]
                                                ['idclient'],
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
      ),
    );
  }

  Widget Enattente(iduser) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(3),
              color: Colors.white,
              child: FutureBuilder(
                future: attente(iduser),
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
                                top: 20, left: 4, right: 4, bottom: 40),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 6,
                                    offset: Offset(1, 1),
                                  ),
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
                                                'assets/images/clientpic.jpg',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${snapshot.data[i]['nameclient']}'
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
                                                if (difference2.inMinutes > 60)
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
                                        'Prix de coli :',
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
                                        'Votre demande de prix :',
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
                                  margin: EdgeInsets.only(top: 2, bottom: 2),
                                  padding: EdgeInsets.only(
                                      top: 10, left: 5, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date et heure de debut :',
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
                                        'Le : ${snapshot.data[i]['date']} A : ${snapshot.data[i]['time']}.',
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

  Widget Rejeter(iduser) {
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
                future: rejeter(iduser, searchRejeter),
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
                                  BoxShadow(
                                    blurRadius: 6,
                                    offset: Offset(1, 1),
                                  ),
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
                                                'assets/images/clientpic.jpg',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${snapshot.data[i]['clientname']}'
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
                                                  '${snapshot.data[i]['reference']}',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 79, 76, 76),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                  ),
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
                                                Color.fromARGB(255, 79, 77, 77),
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
                                        'Date de rejé :',
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
                                        'Le : ${snapshot.data[i]['daterejeter']}.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 79, 77, 77),
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
                                          'Commentaire de client :',
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
                                                  255, 79, 77, 77),
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
                                if (snapshot.data[i]['etoile'] == null &&
                                    snapshot.data[i]['message'] == null)
                                  Container(
                                    width: double.infinity,
                                    child: Expanded(
                                      child: MaterialButton(
                                        height: 45,
                                        color: Colors.white,
                                        child: Text(
                                          "Le client n'a pas encore donné son avis.",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 148, 31, 22),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: null,
                                      ),
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

  Widget Livrer(iduser) {
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
                future: livrer(iduser, searchLivrer),
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
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 6,
                                    offset: Offset(1, 1),
                                  ),
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
                                                'assets/images/clientpic.jpg',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${snapshot.data[i]['clientname']}'
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
                                        alignment: Alignment.centerRight,
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
                                                  '${snapshot.data[i]['reference']}',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 79, 77, 77),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                  ),
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
                                        'Livrer A :',
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
                                        'Le : ${snapshot.data[i]['datelivrer']}.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 79, 77, 77),
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
                                          'Commentaire de client',
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
                                                  255, 79, 77, 77),
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
                                          'Client Avis :',
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
                                if (snapshot.data[i]['etoile'] == null &&
                                    snapshot.data[i]['message'] == null)
                                  Container(
                                    width: double.infinity,
                                    child: Expanded(
                                      child: MaterialButton(
                                        height: 45,
                                        color: Colors.white,
                                        child: Text(
                                          "Le client n'a pas encore donné son avis.",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 148, 31, 22),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: null,
                                      ),
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
}
