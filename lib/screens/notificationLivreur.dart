import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationLivreur extends StatefulWidget {
  const NotificationLivreur({super.key});

  @override
  State<NotificationLivreur> createState() => _NotificationState();
}

class _NotificationState extends State<NotificationLivreur> {
  Future shownotf(idlivreur) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/shownotiLivreur'),
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
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final idlivreur = args['idlivreur'];

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Notfication'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: FutureBuilder(
                future: shownotf(idlivreur),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        DateTime date =
                            DateTime.parse(snapshot.data[i]['temp']);

                        return Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 252, 225, 141),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${snapshot.data[i]['title']}'
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${date.hour}:${date.minute}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${snapshot.data[i]['message']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
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
