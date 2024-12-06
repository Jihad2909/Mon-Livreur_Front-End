import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:monlivreur/screens/homeClient.dart';
import 'package:monlivreur/screens/homeLivreur.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _isLoading = false;
  final _formkey = GlobalKey<FormState>();
  String tokenDevice = '';
  final storage = new FlutterSecureStorage();
  List datauser = [];

  Future login(String email, String password, token) async {
    var response =
        await http.post(Uri.parse('http://10.0.2.2:8000/api/login'), body: {
      'email': email.toString(),
      'password': password.toString(),
      'devicetoken': token.toString(),
    });

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        datauser.add(ok);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) {
      print(value);
      tokenDevice = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  height: 200,
                  child: Stack(children: [
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Image.asset(
                          'assets/images/phone.png',
                          height: 50,
                        )),
                  ]),
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Donner Email';
                    } else {
                      return null;
                    }
                  },
                  controller: _email,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    labelText: 'Email',
                    hintText: 'E-mail',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    prefixIcon: Icon(
                      Iconsax.user,
                      color: Colors.black,
                      size: 18,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade200, width: 2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Color.fromARGB(255, 253, 69, 13),
                      fontSize: 18.0,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 246, 206, 29), width: 1.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Donner password';
                    } else {
                      return null;
                    }
                  },
                  controller: _password,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    labelText: 'Mot de passe',
                    hintText: 'Mot de passe',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Icon(
                      Iconsax.key,
                      color: Colors.black,
                      size: 18,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade200, width: 2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 246, 206, 29), width: 1.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgetpassword');
                      },
                      child: Text(
                        'Mot de passe Oublié?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: MaterialButton(
                    minWidth: double.infinity,
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        await login(_email.text, _password.text, tokenDevice);

                        if (datauser[datauser.length - 1]['succes'] ==
                                'succes' &&
                            datauser[datauser.length - 1]['typeuser'] == 2) {
                          Future.delayed(Duration(seconds: 3), () {
                            setState(() {
                              _isLoading = false;
                            });

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HomeLivreur(
                                    iduser: datauser[datauser.length - 1]
                                        ['iduser']),
                              ),
                            );
                          });
                        } else if (datauser[datauser.length - 1]['succes'] ==
                                'succes' &&
                            datauser[datauser.length - 1]['typeuser'] == 1) {
                          Future.delayed(Duration(seconds: 3), () {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => HomeClient(
                                      iduser: datauser[datauser.length - 1]
                                          ['iduser'])),
                            );
                          });
                        } else if (datauser[datauser.length - 1]['error'] ==
                            'error') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 2),
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
                                    "Information incorrect !",
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
                        }
                      } else {
                        return null;
                      }
                    },
                    color: Colors.yellow,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
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
                            "login",
                            style: TextStyle(
                                color: Color.fromARGB(255, 185, 89, 0)),
                          ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vous n'avez pas un Compte?",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/phone');
                      },
                      child: Text(
                        "S'inscrire",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
