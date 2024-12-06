import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  List dataphone = [];
  bool ok = false;
  TextEditingController phonenumber = TextEditingController();
  TextEditingController code = TextEditingController();

  Future getcode(phone) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/checkforgetPassword'),
      body: {
        'phonenumber': phone.toString(),
      },
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        dataphone.add(ok);
      });
      print(dataphone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mot de passe Oublié ?'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 220, 218, 218),
            border: Border.all(width: 1),
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                offset: Offset(0, 0),
              ),
            ],
          ),
          margin: EdgeInsets.only(top: 150, left: 8, right: 8),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50, right: 8, left: 8),
                child: TextFormField(
                  controller: phonenumber,
                  onChanged: (value) {},
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Votre numéro de télephone',
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20, right: 15, left: 15),
                child: MaterialButton(
                  height: 45,
                  color: Colors.white,
                  onPressed: () async {
                    if (phonenumber.text.isEmpty) {
                      return null;
                    } else {
                      await getcode(phonenumber.text);

                      if (dataphone[dataphone.length - 1]['succes'] ==
                          'succes') {
                        setState(() {
                          ok = true;
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Center(
                                child: Text(
                                  "Numéro introuvable ",
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
                      }
                    }
                  },
                  child: Text(
                    'Envoyer Code',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (ok == true)
                Container(
                  margin: EdgeInsets.only(top: 25, right: 8, left: 8),
                  child: TextFormField(
                    controller: code,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Tapez le code envoyer',
                    ),
                  ),
                ),
              if (ok == true)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20, right: 15, left: 15),
                  child: MaterialButton(
                    height: 45,
                    color: Colors.white,
                    onPressed: () {
                      if (code.text.isEmpty) {
                        return null;
                      }
                      if (dataphone[dataphone.length - 1]['code'].toString() ==
                          code.text) {
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.pushNamed(context, '/newpassword',
                              arguments: {
                                'iduser': dataphone[dataphone.length - 1]
                                        ['iduser']
                                    .toString(),
                              });
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Center(
                                child: Text(
                                  "code incorrect ",
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
                      }
                    },
                    child: Text(
                      'verifier Code',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
