import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Portfeuille extends StatefulWidget {
  const Portfeuille({super.key});

  @override
  State<Portfeuille> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Portfeuille> {
  List portData = [];

  Future getportfeuille(idlivreur) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/getportfeuille'),
      body: {'idlivreur': idlivreur.toString()},
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      return ok;
    }
  }

  Future historique(idlivreur) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/historiqueAffichage'),
      body: {'idlivreur': idlivreur.toString()},
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      return ok;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final idlivreur = args['idlivreur'];

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            height: 230,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                    offset: Offset(1, 1), // Shadow position
                  ),
                ],
                border: Border.all(width: 0),
                color: Color.fromARGB(255, 216, 241, 75)),
            child: Container(
              child: FutureBuilder(
                future: getportfeuille(idlivreur.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.only(top: 20, left: 25, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Portfeuille'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              Image.asset(
                                'assets/images/master2.png',
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Solde : ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 78, 73, 73),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${snapshot.data['solde']} TND',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 14, 73, 42),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Solde bloqué : ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 78, 73, 73),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${snapshot.data['soldebloque']} TND',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 149, 43, 34),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: double.infinity,
                          padding: EdgeInsets.only(right: 20, top: 30),
                          child: Text(
                            '${snapshot.data['nom']}'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 60, 64, 189),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                    ;
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 0, color: Colors.black),
                color: Color.fromARGB(255, 231, 255, 94),
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                    offset: Offset(1, 1), // Shadow position
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Historique',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey))),
                    padding: EdgeInsets.only(
                        left: 20, top: 25, right: 40, bottom: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ref Coli',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Prix Enlevé',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Etat',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ]),
                  ),
                  Expanded(
                    child: Container(
                      child: FutureBuilder(
                        future: historique(idlivreur.toString()),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        top: 5, left: 5, right: 5, bottom: 5),
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      border: Border.all(
                                          width: 1, color: Colors.white),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${snapshot.data[i]['ref']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          '- ${snapshot.data[i]['prixenleve']} TND',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        if (snapshot.data[i]['etat'] ==
                                            'propose')
                                          Text(
                                            'Proposé',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54),
                                          ),
                                        if (snapshot.data[i]['etat'] ==
                                            'accepter')
                                          Text(
                                            'Accepter',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                        if (snapshot.data[i]['etat'] ==
                                            'annuler')
                                          Text(
                                            'Annuler',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
