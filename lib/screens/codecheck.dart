import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_verification_code/flutter_verification_code.dart';


class MyCheckCode extends StatefulWidget {
  const MyCheckCode({Key? key}) : super(key: key);
  @override
  _CheckCode createState() => _CheckCode();
}

class _CheckCode extends State<MyCheckCode> {
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;
  bool premierfois = true;
  List data = [];
  List data2 = [];
  int? code;

  Future getcode(String phone) async {
    var response =
        await http.post(Uri.parse('http://10.0.2.2:8000/api/code'), body: {
      'field': 'phone',
      'values': phone,
    });

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        data.add(ok);
      });
    }
  }

  Future checkcode(String code, String auth) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/checkcode'),
      body: {
        'auth': auth,
        'code': code,
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      var ok = jsonDecode(response.body);
      setState(() {
        data2.add(ok);
      });
    }
  }

  String _code = '';
  // ignore: unused_field
  late Timer _timer;
  int _start = 60;
  int _currentIndex = 0;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      if (this.mounted) {
        setState(() {
          if (_start == 0) {
            _start = 120;
            _isResendAgain = false;
            timer.cancel();
          } else {
            _start--;
          }
        });
      }
    });
  }

  verify() {
    setState(() {
      _isLoading = true;
    });

    const oneSec = Duration(milliseconds: 2000);
    _timer = new Timer.periodic(oneSec, (timer) {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
          _isVerified = true;
        });
      }
    });
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (this.mounted) {
        setState(() {
          _currentIndex++;

          if (_currentIndex == 3) _currentIndex = 0;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final phone = args['phone'];
    final auth = args['auth'];

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 250,
                    child: Stack(children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AnimatedOpacity(
                          opacity: _currentIndex == 0 ? 1 : 0,
                          duration: Duration(
                            seconds: 1,
                          ),
                          curve: Curves.linear,
                          child: Image.asset(
                            'assets/images/phone.png',
                            height: 50,
                          ),
                        ),
                      )
                    ]),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      child: Text(
                    "Vérification",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Text(
                      "Entrer le code envoyer a \n $phone",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                          height: 1.5),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  // Verification Code Input
                  Container(
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vous n'avez pas le Code?",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade500),
                        ),
                        TextButton(
                            onPressed: () async {
                              if (!_isResendAgain) {
                                setState(() {
                                  premierfois = false;
                                });
                                resend();
                                await getcode(phone);
                                print(
                                    'new code : ${data[data.length - 1]['Code']}');
                              }
                            },
                            child: Text(
                              _isResendAgain
                                  ? "Renvoyer in " + _start.toString()
                                  : "Renvoyer",
                              style: TextStyle(color: Colors.blueAccent),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: MaterialButton(
                      elevation: 0,
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        if (premierfois) {
                          code = args['code'];
                        } else {
                          code = data[data.length - 1]['Code'];
                        }

                        if (_code != code.toString()) {
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
                                    "Code Incorrect",
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
                        } else {
                          await checkcode(_code, auth);
                          verify();

                          Future.delayed(Duration(seconds: 4), () {
                            Navigator.pushNamed(context, '/usertype',
                                arguments: {
                                  'idphone': data2[0]['IDphone'],
                                });
                          });
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      color: Colors.orange.shade400,
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: _isLoading
                          ? Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 3,
                                color: Colors.black,
                              ),
                            )
                          : _isVerified
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : Text(
                                  "Verify",
                                  style: TextStyle(color: Colors.white),
                                ),
                    ),
                  )
                ],
              )),
        ));
  }
}
