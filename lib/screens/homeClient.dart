import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:monlivreur/screens/addcolisClient.dart';
import 'colisClient.dart';
import 'profileClient.dart';

class HomeClient extends StatefulWidget {
  final iduser;
  const HomeClient({super.key, required this.iduser});

  @override
  State<HomeClient> createState() => _MyWidgetState(iduser);
}

class _MyWidgetState extends State<HomeClient> {
  int iduser;
  _MyWidgetState(this.iduser);

  int currentTab = 0;

  PageStorageBucket bucket = PageStorageBucket();
  late Widget currentScreen = ColisClient(idclient: iduser);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: PageStorage(bucket: bucket, child: currentScreen),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 228, 206, 80),
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              currentScreen = AddColisClient(iduser: iduser);
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
                          currentScreen = ColisClient(idclient: iduser);
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home,
                              color: currentTab == 0
                                  ? Color.fromARGB(255, 131, 112, 9)
                                  : Colors.grey),
                          Text(
                            'Colis',
                            style: TextStyle(
                                color: currentTab == 0
                                    ? Color.fromARGB(255, 131, 112, 9)
                                    : Colors.grey),
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
                          currentScreen = ProfileClient(iduser: iduser);
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
