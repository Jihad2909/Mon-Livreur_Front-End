import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpPhone extends StatefulWidget {
  const UpPhone({super.key});

  @override
  State<UpPhone> createState() => _UpPhoneState();
}

class _UpPhoneState extends State<UpPhone> {
  bool _isLoading = false;
  List data = [];
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future updatePhone(String phone, String password, String iduser) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/updatePhone'),
      body: {
        'iduser': iduser.toString(),
        'phonenumber': phone.toString(),
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
        appBar: AppBar(
          title: Text('Mettre a jour'),
        ),
        backgroundColor: Color.fromARGB(255, 222, 221, 220),
        body: Form(
            key: _formkey,
            child: Padding(
              padding: EdgeInsets.only(top: 40, left: 15, right: 15),
              child: ListView(
                children: [
                  Center(
                    child: Text('Numéro télephone',
                        style: TextStyle(fontSize: 30, color: Colors.black)),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  TextFormField(
                    maxLength: 12,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your new phone';
                      } else {
                        return null;
                      }
                    },
                    controller: phone,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelStyle: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                      ),
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'Phone',
                      hintText: 'Your new phonenumber',
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
                      prefixIcon: Icon(Icons.password),
                      labelStyle: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                      ),
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'Password',
                      hintText: 'Your Password',
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
                        if (phone.text.isEmpty || password.text.isEmpty) {
                          setState(() {
                            _isLoading = false;
                          });
                          return null;
                        } else {
                          await updatePhone(
                              phone.text, password.text, iduser.toString());

                          if (data[data.length - 1]['succes'] == 'succes') {
                            Navigator.pushNamed(context, '/checkupPhone',
                                arguments: {
                                  'iduser': iduser.toString(),
                                  'code': data[data.length - 1]['code'],
                                  'auth': data[data.length - 1]['auth'],
                                });
                            setState(() {
                              _isLoading = false;
                            });
                          } else if (data[data.length - 1]['error'] ==
                              'error') {
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
                                      "Numero Exist déjat",
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
                          } else if (data[data.length - 1]['errorps'] ==
                              'errorps') {
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
                                      "Mot de paase Incorrect ",
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
                      color: Colors.green,
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
                              "Update Phone",
                              style: TextStyle(color: Colors.black),
                            ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
