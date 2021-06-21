library my_prj.globals;

// ignore: import_of_legacy_library_into_null_safe
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:connectivity/connectivity.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isConnected = true;
String globalurl = "https://canpeches-boujdour.000webhostapp.com/mobileapi";
String userEmail = "";
String userPass = "";
String userId = "", userName = "", userLastName = "";
String poissonid = "";
late Map compteInfo;
BoxDecoration background() {
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.indigo.shade900, Colors.white]));
}

charts.BarLabelDecorator labelDecorator() {
  return new charts.BarLabelDecorator<String>(
      insideLabelStyleSpec: new charts.TextStyleSpec(
          color: charts.ColorUtil.fromDartColor(Colors.white), fontSize: 10));
}

charts.NumericAxisSpec primaryAxisDecorator() {
  return new charts.NumericAxisSpec(
      renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.black))),
      tickProviderSpec:
          new charts.BasicNumericTickProviderSpec(desiredTickCount: 5));
}

Future<bool> isInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network, make sure there is actually a net connection.
    if (await DataConnectionChecker().hasConnection) {
      // Mobile data detected & internet connection confirmed.
      return true;
    } else {
      // Mobile data detected but no internet connection found.
      return false;
    }
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // I am connected to a WIFI network, make sure there is actually a net connection.
    if (await DataConnectionChecker().hasConnection) {
      // Wifi detected & internet connection confirmed.
      return true;
    } else {
      // Wifi detected but no internet connection found.
      return false;
    }
  } else {
    // Neither mobile data or WIFI detected, not internet connection found.
    return false;
  }
}

Widget notConnected() {
  return Container(
      height: 350.0,
      width: 350.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints.expand(height: 150.0, width: 150.0),
              decoration: BoxDecoration(color: Colors.white),
              child: Image.asset(
                'assets/images/no-internet.png',
                fit: BoxFit.fill,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5.0)),
            Text(
              "Veuillez vous connecter à l'internet",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ]));
}
