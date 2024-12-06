import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;

class NewForgetPassword extends StatefulWidget {
  const NewForgetPassword({super.key});

  @override
  State<NewForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<NewForgetPassword> {
  List dataphone = [];
  bool ok = false;
  TextEditingController password = TextEditingController();
  TextEditingController newpassword = TextEditingController();

  Future updatepass(iduser, password) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/newpassorgetPassword'),
      body: {
        'iduser': iduser.toString(),
        'newpassword': password.toString(),
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
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final iduser = args['iduser'];

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 350,
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
                  controller: password,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'Nouveau mot de passe',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25, right: 8, left: 8),
                child: TextFormField(
                  controller: newpassword,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'confirmation mot de passe',
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 50, right: 15, left: 15),
                child: MaterialButton(
                  height: 45,
                  color: Colors.white,
                  onPressed: () async {
                    if (password.text.isEmpty && newpassword.text.isEmpty) {
                      return null;
                    }

                    if (password.text != newpassword.text) {
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
                                "verifier confimation password",
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
                    await updatepass(iduser, password.text);
                    if (dataphone[dataphone.length - 1]['succes'] == 'succes') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Container(
                            padding: EdgeInsets.all(16),
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Center(
                              child: Text(
                                "Mot de passe changé avec succé",
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
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.pushNamed(context, '/login');
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Container(
                            padding: EdgeInsets.all(16),
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Center(
                              child: Text(
                                "Ressayer",
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
                    'Enregistrer',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
