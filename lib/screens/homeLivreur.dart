import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'alertEmplois.dart';
import 'colisLivreur.dart';
import 'profileLivreur.dart';

class HomeLivreur extends StatefulWidget {
  final iduser;
  const HomeLivreur({super.key, required this.iduser});

  @override
  State<HomeLivreur> createState() => _MyWidgetState(iduser);
}

class _MyWidgetState extends State<HomeLivreur> {
  int iduser;

  _MyWidgetState(this.iduser);
  int currentTab = 0;
  late Widget currentScreen = ColisLivreur(iduser: iduser);
  PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: PageStorage(bucket: bucket, child: currentScreen),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 228, 206, 80),
          child: Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              currentScreen = AlertEmplois(idlivreur: iduser);
              currentTab = 1;
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = ColisLivreur(iduser: iduser);
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home,
                              color: currentTab == 0
                                  ? Color.fromARGB(255, 131, 112, 9)
                                  : Colors.black),
                          Text(
                            'Colis',
                            style: TextStyle(
                                color: currentTab == 0
                                    ? Color.fromARGB(255, 131, 112, 9)
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = ProfileLivreur(idlivreur: iduser);
                          currentTab = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.update,
                              color: currentTab == 2
                                  ? Color.fromARGB(255, 131, 112, 9)
                                  : Colors.black),
                          Text(
                            'Profile',
                            style: TextStyle(
                                color: currentTab == 2
                                    ? Color.fromARGB(255, 131, 112, 9)
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
