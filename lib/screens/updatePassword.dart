import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpPassword extends StatefulWidget {
  const UpPassword({super.key});

  @override
  State<UpPassword> createState() => _UpPasswordState();
}

class _UpPasswordState extends State<UpPassword> {
  bool _isLoading = false;
  List data = [];
  TextEditingController Lastpassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController confpassword = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  Future updatePassword(iduser, Lastpassword, newpassword) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/updatePassword'),
      body: {
        'iduser': iduser.toString(),
        'lastpassword': Lastpassword.toString(),
        'newpassword': newpassword.toString(),
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
    String iduser = args['id'];

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
                child: Text('Mot de passe',
                    style: TextStyle(fontSize: 30, color: Colors.black)),
              ),
              SizedBox(
                height: 100,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Your Last Password';
                  } else {
                    return null;
                  }
                },
                controller: Lastpassword,
                style: TextStyle(
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                  contentPadding: EdgeInsets.only(bottom: 5),
                  hintText: 'Ancien mot de passe',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Your New Password';
                  } else {
                    return null;
                  }
                },
                controller: newpassword,
                style: TextStyle(
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                  contentPadding: EdgeInsets.only(bottom: 5),
                  hintText: 'Nouveau mot de passe',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Your Confirmation Password';
                  } else {
                    return null;
                  }
                },
                controller: confpassword,
                style: TextStyle(
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                  contentPadding: EdgeInsets.only(bottom: 5),
                  hintText: ' Confirmation mot de passe',
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
                    if (Lastpassword.text.isEmpty ||
                        newpassword.text.isEmpty ||
                        confpassword.text.isEmpty) {
                      setState(() {
                        _isLoading = false;
                      });
                      return null;
                    } else if (newpassword.text != confpassword.text) {
                      setState(() {
                        _isLoading = false;
                      });
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
                                "Verifier confirmation Mot de passe ",
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
                      await updatePassword(
                          iduser, Lastpassword.text, newpassword.text);

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
                                  "Mot de passe changé avec succé ! ",
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

                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.pop(context);
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
                                  "Ancien Mot de passe Incorrect ",
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
                    borderRadius: BorderRadius.circular(5),
                  ),
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
                          "Enregistrer",
                          style: TextStyle(
                            color: Colors.black,
                          ),
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
