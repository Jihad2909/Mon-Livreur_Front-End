import 'package:flutter/material.dart';

class UserType extends StatefulWidget {
  const UserType({Key? key}) : super(key: key);

  @override
  _UserTypePageState createState() => _UserTypePageState();
}

class _UserTypePageState extends State<UserType> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final idphone = args['idphone'];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.amber,
          body: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(top: 250, left: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          'Choose AccountType',
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
                            'Choisir quelle compte pour register',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/clientRegister',
                              arguments: {
                                'idphone': idphone,
                              });
                          ;
                        },
                        height: 45,
                        minWidth: double.infinity,
                        color: Colors.black,
                        child: Text(
                          "Client",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/livreurRegister',
                              arguments: {
                                'idphone': idphone,
                              });
                        },
                        height: 45,
                        minWidth: double.infinity,
                        color: Colors.black,
                        child: Text(
                          "livreur",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ],
                  )))),
    );
  }
}
