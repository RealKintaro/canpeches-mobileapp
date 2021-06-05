import 'package:canpeches/models/stockphysique.dart';
import 'package:canpeches/screens/appdrawer.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  HomeController createState() => HomeController();
}

class HomeController extends State<Home> {
  late List poissonsCount;
  List<Stockphysique> stock = [];
  bool showgraphs = false;
  bool visible = true;

  String countfish = "0", countuser = "0", countachats = "0", countvents = "0";
  Future getPoissonsCount() async {
    var url = globals.globalurl + "/getPoissonsCount.php";
    http.Response response = await http.get(Uri.parse(url));
    setState(() {
      poissonsCount = json.decode(response.body);
      countfish = poissonsCount[1]["countfish"];
      countuser = poissonsCount[0]["countuser"];
    });
  }

  Future getAchatCount() async {
    var url = globals.globalurl + "/getImportsCount.php";
    http.Response response = await http.get(Uri.parse(url));
    setState(() {
      poissonsCount = json.decode(response.body);
      countachats = poissonsCount[0]["countimports"];
    });
  }

  Future getVentsCount() async {
    var url = globals.globalurl + "/getExportsCount.php";
    http.Response response = await http.get(Uri.parse(url));
    setState(() {
      poissonsCount = json.decode(response.body);
      countvents = poissonsCount[0]["countexports"];
    });
  }

  List<Stockphysique> fromJson(String strJson) {
    final data = jsonDecode(strJson);
    return List<Stockphysique>.from(data.map((i) => Stockphysique.fromMap(i)));
  }

  Future getStock() async {
    var url = globals.globalurl + "/allstockphysique.php";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        stock = fromJson(response.body);
        showgraphs = true;
        visible = false;
      });
    }
  }

  static List<charts.Series<Stockphysique, String>> chartData(
      List<Stockphysique> data) {
    return [
      charts.Series<Stockphysique, String>(
          id: 'Stock',
          domainFn: (Stockphysique s, _) => s.fishname,
          measureFn: (Stockphysique s, _) => s.stocknumber,
          labelAccessorFn: (Stockphysique s, _) => s.stocknumber.toString(),
          data: data)
    ];
  }

  @override
  void initState() {
    super.initState();
    getPoissonsCount();
    getAchatCount();
    getVentsCount();
    getStock();

    AppDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          "Page d'accueil",
        ),
        actions: [
          IconButton(
            tooltip: "Deconnecter",
            icon: const Icon(
              Icons.power_settings_new_outlined,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text("Voulez vous se deconnexter?"),
                    actions: <Widget>[
                      TextButton(
                        child: new Text("OK"),
                        onPressed: () {
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: globals.background(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 250,
                width: 350.0,
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 85.0,
                          width: MediaQuery.of(context).size.width / 2 - 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 55.0,
                                width: 55.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/fish1.png",
                                      ),
                                      fit: BoxFit.fill),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Text(
                                "ESPÈCES:",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5.0)),
                        Text(
                          countfish,
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        Padding(padding: EdgeInsets.all(25.0)),
                        Container(
                          height: 85.0,
                          width: MediaQuery.of(context).size.width / 2 - 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 55.0,
                                width: 55.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/import.png",
                                      ),
                                      fit: BoxFit.fill),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Text(
                                "Les Achats:",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5.0)),
                        Text(
                          countachats,
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(10.0)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 85.0,
                          width: MediaQuery.of(context).size.width / 2 - 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 55.0,
                                width: 55.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/profile.png",
                                      ),
                                      fit: BoxFit.fill),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Text(
                                "UTILISATEURS ACTIVES",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5.0)),
                        Text(
                          countuser,
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        Padding(padding: EdgeInsets.all(25.0)),
                        Container(
                          height: 85.0,
                          width: MediaQuery.of(context).size.width / 2 - 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 55.0,
                                width: 55.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/export.png",
                                      ),
                                      fit: BoxFit.fill),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Text(
                                "Les Vents",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5.0)),
                        Text(
                          countvents,
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  height: 400.0,
                  width: 400,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: graphs(showgraphs),
                    ),
                  )),
            ],
          )),
      drawer: AppDrawer(),
    );
  }

  Widget graphs(bool test) {
    if (test) {
      return Column(
        children: [
          Text(
            "Stock des poissons:",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Expanded(
            child: charts.BarChart(
              chartData(stock.length > 5 ? stock.sublist(0, 5) : stock),
              animate: true,
              barRendererDecorator: globals.labelDecorator(),
              primaryMeasureAxis: globals.primaryAxisDecorator(),
            ),
          ),
          Expanded(
            child: charts.BarChart(
              chartData(stock.length > 5 ? stock.sublist(5) : stock),
              animate: true,
              barRendererDecorator: globals.labelDecorator(),
              primaryMeasureAxis: globals.primaryAxisDecorator(),
            ),
          )
        ],
      );
    } else {
      return Center(
          child: Visibility(
              visible: visible,
              child: Container(
                  width: 69.0,
                  height: 69.0,
                  margin: EdgeInsets.only(bottom: 10),
                  child: CircularProgressIndicator())));
    }
  }
}
