import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Negocie extends StatefulWidget {
  const Negocie({super.key});

  @override
  State<Negocie> createState() => _NegocieState();
}

class _NegocieState extends State<Negocie> {
  TextEditingController price = TextEditingController();
  TextEditingController test = TextEditingController();
  List data = [];
  int _price = 0;
  int prixlivreur = 0;

  Future negpcier(idcoli, idclient, idlivreur, prixnegocie, soldebloque) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/negociePrix'),
      body: {
        'idcoli': idcoli.toString(),
        'idclient': idclient.toString(),
        'idlivreur': idlivreur.toString(),
        'prixnegocie': prixnegocie.toString(),
        'soldebloque': soldebloque.toString(),
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

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final prixclient = args['prixclient'];
    final idcoli = args['idcolis'];
    final idlivreur = args['idlivreur'];
    final idclient = args['idclient'];
    final soldebloque = args['soldeb'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text('Negocier Le prix')),
      ),
      body: Center(
        child: Container(
          height: 330,
          width: 350,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 233, 224, 224),
              border: Border.all(width: 1, color: Colors.black),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: Offset(1, 1),
                ),
              ]),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: test,
                readOnly: true,
                decoration: InputDecoration(
                  hintText:
                      'Max : ${((prixclient * 20 / 100) + prixclient).round()} TND',
                ),
              ),
              TextFormField(
                controller: test,
                readOnly: true,
                decoration: InputDecoration(
                  hintText:
                      'min : ${(prixclient - (prixclient * 20 / 100)).round()} TND ',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: price,
                readOnly: true,
                onTap: () {
                  price.text = prixclient.toString();
                  _price = int.parse(price.text);
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Tab here to get prix',
                  prefixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        if (price.text.isEmpty) {
                          return null;
                        }

                        var percentage = prixclient * 20 / 100;
                        var max = prixclient + percentage;
                        if (int.parse(price.text) == max.round()) {
                          setState(() {});
                          return null;
                        } else {
                          setState(() {
                            _price = _price + 1;
                            price.text = _price.toString();
                          });
                          setState(() {});
                        }
                        prixlivreur = int.parse(price.text);
                      }),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (price.text.isEmpty) {
                        return null;
                      }
                      var percentage = prixclient * 20 / 100;
                      var min = prixclient - percentage;

                      if (int.parse(price.text) == min.round()) {
                        setState(() {});
                        return null;
                      } else {
                        setState(() {
                          _price = _price - 1;
                          price.text = '$_price';
                        });
                        setState(() {});
                        prixlivreur = int.parse(price.text);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: Color.fromARGB(255, 217, 49, 36),
                        child: Text('Annuler'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: MaterialButton(
                        color: Colors.green,
                        child: Text('Confirmer'),
                        onPressed: () async {
                          if (price.text.isEmpty) {
                            return null;
                          }
                          prixlivreur = int.parse(price.text);
                          await negpcier(idcoli, idclient, idlivreur,
                              prixlivreur, soldebloque);
                          if (data.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Container(
                                    padding: EdgeInsets.all(16),
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "problem obtenu!",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ))),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                            );
                          } else {
                            if (data[data.length - 1]['succes'] == 'succes') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Container(
                                      padding: EdgeInsets.all(16),
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "Demande de négociation envoyé",
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
                                        "Echec Verifier votre solde",
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
      ),
    );
  }
}
