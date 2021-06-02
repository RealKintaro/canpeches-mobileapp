library my_prj.globals;

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String globalurl = "https://canpeches.000webhostapp.com/mobileapi";
String userEmail = "";
String userName = "";
String poissonid = "";
Map compteInfo;
BoxDecoration background() {
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.indigo[900], Colors.white]));
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
