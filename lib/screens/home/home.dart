import 'package:canpeches/models/stockphysique.dart';
import 'package:canpeches/screens/appdrawer.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  HomeController createState() => HomeController();
}

class HomeController extends State<Home> {
  List poissonsCount;
  List<Stockphysique> stock = [];
  bool showgraphs = false;
  bool visible = true;

  String countfish, countuser = "0";
  Future getPoissonsCount() async {
    var url = globals.globalurl + "/getPoissonsCount.php";
    http.Response response = await http.get(Uri.parse(url));
    setState(() {
      poissonsCount = json.decode(response.body);
      countfish = poissonsCount[1]["countfish"];
      countuser = poissonsCount[0]["countuser"];
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
                          height: 95.0,
                          width: 140.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 65.0,
                                width: 70.0,
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
                                "NOMBRE D'ESPÈCES:",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5.0)),
                        Text(
                          countfish == null ? "0" : countfish,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(10.0)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 95.0,
                          width: 140.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 65.0,
                                width: 70.0,
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
                                "NOMBRE D'UTILISATEURS",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5.0)),
                        Text(
                          countuser == null ? "0" : countuser,
                          style: TextStyle(
                              fontSize: 25,
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
              chartData(stock.sublist(0, 5)),
              animate: true,
              barRendererDecorator: globals.labelDecorator(),
              primaryMeasureAxis: globals.primaryAxisDecorator(),
            ),
          ),
          Expanded(
            child: charts.BarChart(
              chartData(stock.sublist(5)),
              animate: true,
              barRendererDecorator: globals.labelDecorator(),
              primaryMeasureAxis: globals.primaryAxisDecorator(),
            ),
          )
        ],
      );
    } else {
      return new Visibility(
          visible: visible,
          child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: CircularProgressIndicator()));
    }
  }
}
