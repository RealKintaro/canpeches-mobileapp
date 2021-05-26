import 'package:canpeches/screens/gestcomptes/homecomptes.dart';
import 'package:canpeches/screens/gestpoissons/gestpoissons.dart';
import 'package:canpeches/screens/gestpoissons/homepoissons.dart';
import 'package:canpeches/screens/home/home.dart';
import 'package:canpeches/screens/importexport/export.dart';
import 'package:canpeches/screens/importexport/import.dart';
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
      },
    );
  }
}
