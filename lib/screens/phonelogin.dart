import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  @override
  PhoneLogin createState() => PhoneLogin();
}

class PhoneLogin extends State<MyPhone> {
  final TextEditingController controller = TextEditingController();
  bool _isLoading = false;
  PhoneNumber? _phoneNumber;
  String num = '';
  final _formkey = GlobalKey<FormState>();
  List data = [];

  Future getcode(String phone) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/code'),
      body: {
        'field': 'phone',
        'values': phone,
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(234, 175, 37, 1),
        body: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/phone.png',
                    fit: BoxFit.cover,
                    width: 150,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Text(
                      'REGISTER',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.grey.shade900),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20),
                      child: Text(
                        'Entrez votre numéro de téléphone pour continuer, nous vous enverrons un code pour vérifier.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.13)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffeeeeee),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          InternationalPhoneNumberInput(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please inter some text";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _phoneNumber = value;
                            },
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.DIALOG,
                            ),
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: TextStyle(color: Colors.black),
                            textFieldController: controller,
                            formatInput: false,
                            initialValue: PhoneNumber(isoCode: 'TN'),
                            countries: ['TN'],
                            maxLength: 8,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            cursorColor: Colors.black,
                            inputDecoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 15, left: 0),
                              border: InputBorder.none,
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 16),
                            ),
                            onInputChanged: (PhoneNumber value) {
                              print('onchange $value');
                              _phoneNumber = value;
                            },
                          ),
                          Positioned(
                            left: 90,
                            top: 8,
                            bottom: 8,
                            child: Container(
                              height: 40,
                              width: 1,
                              color: Colors.black.withOpacity(0.13),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    child: MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          await getcode(_phoneNumber!.phoneNumber.toString());

                          if (data[data.length - 1]['error'] == 'error') {
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
                                      "Ce numéro exist déja !",
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
                          } else if (data[data.length - 1]['complete'] ==
                              'complete') {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pushNamed(context, '/usertype',
                                arguments: {
                                  'idphone': data[data.length - 1]['idphone'],
                                });
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pushNamed(context, '/check', arguments: {
                              'phone': _phoneNumber!.phoneNumber.toString(),
                              'code': data[data.length - 1]['Code'],
                              'auth': data[data.length - 1]['Auth'],
                            });
                          }
                        } else {
                          return null;
                        }
                      },
                      color: Colors.yellow,
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
                              "Get Code",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 185, 89, 0)),
                            ),
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
                          'Already have an account?',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
