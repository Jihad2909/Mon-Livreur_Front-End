import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:monlivreur/screens/detailsclient.dart';
import 'package:monlivreur/screens/detailslivreur.dart';
import 'package:monlivreur/screens/Livreurinfo.dart';
import 'package:monlivreur/screens/homeLivreur.dart';
import 'package:monlivreur/screens/mapliteraire.dart';
import 'package:monlivreur/screens/negociePrix.dart';
import 'package:monlivreur/screens/notificationClient.dart';
import 'package:monlivreur/screens/notificationLivreur.dart';
import 'package:monlivreur/screens/portfeuille.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monlivreur/screens/checkupPhone.dart';
import 'package:monlivreur/screens/clientRegister.dart';
import 'package:monlivreur/screens/codecheck.dart';
import 'package:monlivreur/screens/livreurRegister.dart';
import 'package:monlivreur/screens/login.dart';
import 'package:monlivreur/screens/menuclient.dart';
import 'package:monlivreur/screens/menulivreur.dart';
import 'package:monlivreur/screens/phonelogin.dart';
import 'package:monlivreur/screens/updateEmail.dart';
import 'package:monlivreur/screens/updatePassword.dart';
import 'package:monlivreur/screens/updatePhone.dart';
import 'package:monlivreur/screens/usertype.dart';
import 'screens/LivreurInfoNull.dart';
import 'screens/firstscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/forgetPass.dart';
import 'screens/homeClient.dart';
import 'screens/nawpassForget.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print('hello from background');
  print(message.notification!.title);
  print(message.notification!.body);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  final iduser = prefs.getInt('iduser') ?? 0;

  runApp(
    MyApp(showHome: showHome),
  );
}

class MyApp extends StatelessWidget {
  final bool showHome;

  const MyApp({
    Key? key,
    required this.showHome,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/phone': (context) => const MyPhone(),
        '/detailsclient': (context) => const DetailsClient(),
        '/detailslivreur': (context) => const DetailsLivreur(),
        '/login': (context) => const Login(),
        '/check': (context) => const MyCheckCode(),
        '/usertype': (context) => const UserType(),
        '/livreurRegister': (context) => const LivreurRegister(),
        '/clientRegister': (context) => const ClientRegister(),
        '/upemail': (context) => const UpEmail(),
        '/upPassword': (context) => const UpPassword(),
        '/upPhone': (context) => const UpPhone(),
        '/checkupPhone': (context) => const CheckupPhone(),
        '/mapliteraire': (context) => const MapLiteraire(),
        '/negocie': (context) => const Negocie(),
        '/portfeuille': (context) => const Portfeuille(),
        '/livreurinfo': (context) => const LivreurInfo(),
        '/livreurinfonull': (context) => const LivreurInfoNull(),
        '/notficationn': (context) => const Notificationn(),
        '/notficationLivreur': (context) => const NotificationLivreur(),
        '/newpassword': (context) => const NewForgetPassword(),
        '/forgetpassword': (context) => const ForgetPassword(),
      },
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'RobotoMono'),
      home: showHome ? const Login() : const MyWidget(),
    );
  }
}
