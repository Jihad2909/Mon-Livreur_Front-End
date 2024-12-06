import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlertEmplois extends StatefulWidget {
  final idlivreur;
  const AlertEmplois({super.key, required this.idlivreur});

  @override
  State<AlertEmplois> createState() => _AlertEmploisState(idlivreur);
}

class _AlertEmploisState extends State<AlertEmplois> {
  int idlivreur;
  _AlertEmploisState(this.idlivreur);

  double soldebloque = 0.0;
  bool? ok;
  String searchalert = '';

  Future alertEmplois(idlivreur, search) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/alertEmplois'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.all(7),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchalert = value;
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
                future: alertEmplois(idlivreur, searchalert),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        final solde = snapshot.data[i]['solde'];
                        final prixcoliss = snapshot.data[i]['prix'];

                        soldebloque = (prixcoliss * 10) / 100;
                        if (solde >= soldebloque) {
                          ok = true;
                        } else {
                          ok = false;
                        }
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 4, left: 4, right: 4, bottom: 40),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 242, 245, 70),
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
                                                    255, 91, 89, 89),
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
                                  padding: EdgeInsets.only(
                                      top: 10, left: 5, bottom: 10),
                                  margin: EdgeInsets.only(bottom: 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Taille :',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 4, 2, 65),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      if (snapshot.data[i]['taille'] == 'petit')
                                        Text(
                                          'Petit (< 10Kg).',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 119, 108, 108),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      if (snapshot.data[i]['taille'] ==
                                          'moyenne')
                                        Text(
                                          'Moyen ([10KG .. 20KG]).',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 119, 108, 108),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      if (snapshot.data[i]['taille'] ==
                                          'grande')
                                        Text(
                                          'grand (30KG).',
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
                                        'Adresse de rammasage:',
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
                                        '${snapshot.data[i]['adR']}',
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
                                        'Adresse distination:',
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
                                        '${snapshot.data[i]['adE']}',
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
                                        'Prix :',
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
                                if (ok == true)
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
                                        "Negocier le prix",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/negocie',
                                            arguments: {
                                              'idlivreur': idlivreur.toString(),
                                              'idcolis': snapshot.data[i]
                                                  ['idcolis'],
                                              'prixclient': snapshot.data[i]
                                                  ['prix'],
                                              'idclient': snapshot.data[i]
                                                  ['idclient'],
                                              'soldeb': soldebloque,
                                            });
                                      },
                                    ),
                                  ),
                                if (ok == false)
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
                                      color: Colors.red,
                                      child: Text(
                                        "Vous devez avoir minmum ${soldebloque}DT\ndans votre solde pour negocié.",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: null,
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
