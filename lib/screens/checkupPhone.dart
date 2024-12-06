import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:http/http.dart' as http;

class CheckupPhone extends StatefulWidget {
  const CheckupPhone({super.key});

  @override
  State<CheckupPhone> createState() => _CheckupPhoneState();
}

class _CheckupPhoneState extends State<CheckupPhone> {
  bool _isLoading = false;
  List data = [];
  String _code = '';

  final _formkey = GlobalKey<FormState>();

  Future updatephone(String code, String auth, String iduser) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/updatePhoneCheck'),
      body: {
        'iduser': iduser.toString(),
        'auth': auth.toString(),
        'code': code.toString(),
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        data.add(ok);
      });
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final iduser = args['iduser'];
    final code = args['code'];
    final auth = args['auth'];

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
                    child: Text('Tapez le code envoyé',
                        style: TextStyle(fontSize: 30, color: Colors.black)),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Container(
                      child: VerificationCode(
                        length: 4,
                        textStyle: TextStyle(fontSize: 20, color: Colors.black),
                        underlineColor: Colors.black,
                        keyboardType: TextInputType.number,
                        underlineUnfocusedColor: Colors.black,
                        onCompleted: (value) {
                          setState(() {
                            _code = value;
                          });
                        },
                        onEditing: (bool value) {},
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () async {
                        print(_code);
                        print(code);
                        if (_code.toString() != code.toString()) {
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
                                    "Code incorrect",
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
                        } else {
                          await updatephone(
                              code.toString(), auth, iduser.toString());

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
                                      "Numero changer avec succé",
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
                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pop(
                              context,
                            );
                            Navigator.pop(
                              context,
                            );
                          });
                        }
                      },
                      height: 50,
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
                              "Enregistrer",
                              style: TextStyle(color: Colors.black),
                            ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
