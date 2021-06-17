import 'package:canpeches/screens/gestcomptes/addcompte.dart';
import 'package:canpeches/screens/gestcomptes/gestcompte.dart';
import 'package:canpeches/screens/historique/historiquecomptes.dart';
import 'package:canpeches/screens/historique/historiqueconnections.dart';
import 'package:canpeches/screens/historique/historiqueoperations.dart';
import 'package:canpeches/screens/gestcomptes/homecomptes.dart';
import 'package:canpeches/screens/gestpoissons/gestpoissons.dart';
import 'package:canpeches/screens/gestpoissons/homepoissons.dart';
import 'package:canpeches/screens/home/home.dart';
import 'package:canpeches/screens/importexport/export.dart';
import 'package:canpeches/screens/importexport/import.dart';
import 'package:canpeches/screens/login/qrcode.dart';
import 'package:canpeches/screens/profile/profile.dart';
import 'package:canpeches/screens/qrcode/qrcodegenerator.dart';
import 'package:flutter/material.dart';
import 'screens/login/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue),
      home: Login(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new Home(),
        '/homePoissons': (BuildContext context) => new HomePoissons(),
        '/gestPoisson': (BuildContext context) => new GestPoissons(),
        '/homeComptes': (BuildContext context) => new HomeComptes(),
        '/getAllImports': (BuildContext context) => new GetAllImports(),
        '/getAllExports': (BuildContext context) => new GetAllExports(),
        '/getHistoriqueComptes': (BuildContext context) =>
            new HistoriqueComptes(),
        '/getHistoriqueOperations': (BuildContext context) =>
            new HistoriqueOperations(),
        '/getHistoriqueConnections': (BuildContext context) =>
            new HistoriqueConnection(),
        '/addCompte': (BuildContext context) => new AddCompte(),
        '/gestCompte': (BuildContext context) => new GestCompte(),
        '/qrCode': (BuildContext context) => new QrScane(),
        '/qrGen': (BuildContext context) => new QrCodeGen(),
        '/profile': (BuildContext context) => new Profile(),
      },
    );
  }
}
