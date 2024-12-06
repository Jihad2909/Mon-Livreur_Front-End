import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpEmail extends StatefulWidget {
  const UpEmail({super.key});

  @override
  State<UpEmail> createState() => _UpEmailState();
}

class _UpEmailState extends State<UpEmail> {
  bool _isLoading = false;

  List data = [];
  TextEditingController newEmail = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future updateEmail(String email, String password, String iduser) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/updateMail'),
      body: {
        'iduser': iduser.toString(),
        'email': email.toString(),
        'password': password.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);

      setState(() {
        data.add(ok);
      });
      print(data[data.length - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String iduser = args['iduser'];
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Color.fromARGB(255, 222, 221, 220),
        body: Form(
            key: _formkey,
            child: Padding(
              padding: EdgeInsets.only(top: 40, left: 15, right: 15),
              child: ListView(
                children: [
                  Center(
                    child: Text('Mette a jour Email',
                        style: TextStyle(fontSize: 30, color: Colors.black)),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your New Email';
                      } else {
                        return null;
                      }
                    },
                    controller: newEmail,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                      ),
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'Email',
                      hintText: 'New Email',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your Password';
                      } else {
                        return null;
                      }
                    },
                    controller: password,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                      ),
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'Password',
                      hintText: 'Password',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        if (newEmail.text.isEmpty || password.text.isEmpty) {
                          setState(() {
                            _isLoading = false;
                          });
                          return null;
                        } else {
                          await updateEmail(
                              newEmail.text, password.text, iduser.toString());

                          if (data[data.length - 1]['succes'] == 'succes') {
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
                                      "Email changé avec succé ! ",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ))),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                            );
                            setState(() {
                              _isLoading = false;
                            });

                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.pop(context);
                            });
                          } else if (data[data.length - 1]['error'] ==
                              'errpass') {
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
                                      "Mot de passe incorrect ",
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
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      child: _isLoading
                          ? Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Update Email",
                              style: TextStyle(color: Colors.black),
                            ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
