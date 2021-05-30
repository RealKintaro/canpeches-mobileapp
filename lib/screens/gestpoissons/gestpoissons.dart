import 'package:canpeches/screens/appdrawer.dart';
import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class GestPoissons extends StatefulWidget {
  @override
  GestPoissonsController createState() => GestPoissonsController();
}

class GestPoissonsController extends State<GestPoissons> {
  final RestorableInt tabIndex = RestorableInt(0);

  List achat, vent;
  bool visible = true;
  Future getStockPoisson() async {
    var url = globals.globalurl + "/getStockPoisson.php";
    var data = {'id': globals.poissonid};
    var response = await http.post(Uri.parse(url), body: json.encode(data));
    setState(() {
      achat = jsonDecode(response.body);
      visible = false;
    });
  }

  Future getventPoisson() async {
    var url = globals.globalurl + "/getExportPoissons.php";
    var data = {'id': globals.poissonid};
    var response = await http.post(Uri.parse(url), body: json.encode(data));
    setState(() {
      vent = jsonDecode(response.body);
    });
  }

  @override
  void initState() {
    getStockPoisson();
    getventPoisson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo[900],
            title: Text(
              "Gestion Poissons",
            ),
            actions: [
              IconButton(
                tooltip: "Recherche",
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () {},
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text("Achats"),
                ),
                Tab(
                  child: Text("Vents"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: globals.background(),
                  child: visible
                      ? Center(
                          child: Visibility(
                              visible: visible,
                              child: Container(
                                  height: 69.0,
                                  width: 69.0,
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  ))))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.only(top: 5.0)),
                            Row(
                              children: [
                                Padding(padding: EdgeInsets.only(left: 10.0)),
                                Text(
                                  "Les Achat:",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                )
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(5.0)),
                            Expanded(
                                child: Container(
                              child: ListView.builder(
                                itemCount: achat == null ? 1 : achat.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == 0) {
                                    // return the header
                                    return Card(
                                        child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      6 -
                                                  5,
                                              child: Center(
                                                child: Text('Date',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      6 +
                                                  35,
                                              child: Center(
                                                child: Text('Maryeur',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      6 -
                                                  5,
                                              child: Center(
                                                child: Text('Num Etat',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      6 -
                                                  20,
                                              child: Center(
                                                child: Text('Qte',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      6 -
                                                  20,
                                              child: Center(
                                                child: Text('Rend',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      6 -
                                                  20,
                                              child: Center(
                                                child: Text('Poids',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              )),
                                        ],
                                      ),
                                    ));
                                  }
                                  index -= 1;
                                  if (achat.isEmpty) {
                                    return Center(
                                      child: Image.asset(
                                        "assets/images/not-found.png",
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }
                                  return Card(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  6,
                                              child: Center(
                                                child: Text(
                                                  achat[index]["date"],
                                                  style: TextStyle(
                                                    color: Colors.indigo[400],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      6 +
                                                  35,
                                              child: Center(
                                                child: Text(
                                                  achat[index]["maryeur"],
                                                  style: TextStyle(
                                                    color: Colors.indigo[400],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      6 -
                                                  5,
                                              child: Center(
                                                child: Text(
                                                  achat[index]["netat"],
                                                  style: TextStyle(
                                                    color: Colors.indigo[400],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      6 -
                                                  20,
                                              child: Center(
                                                child: Text(
                                                  achat[index]["qte"],
                                                  style: TextStyle(
                                                    color: Colors.indigo[400],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      6 -
                                                  20,
                                              child: Center(
                                                child: Text(
                                                  achat[index]["rend"],
                                                  style: TextStyle(
                                                    color: Colors.indigo[400],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      6 -
                                                  20,
                                              child: Center(
                                                child: Text(
                                                  achat[index]["poids"],
                                                  style: TextStyle(
                                                    color: Colors.indigo[400],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )),
                          ],
                        )),
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: globals.background(),
                  child: visible
                      ? Center(
                          child: Visibility(
                              visible: visible,
                              child: Container(
                                  height: 69.0,
                                  width: 69.0,
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  ))))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.only(top: 5.0)),
                            Row(
                              children: [
                                Padding(padding: EdgeInsets.only(left: 10.0)),
                                Text(
                                  "Les Vents:",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                )
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(5.0)),
                            Expanded(
                                child: Container(
                              child: ListView.builder(
                                itemCount: vent == null ? 1 : vent.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == 0) {
                                    // return the header
                                    return Card(
                                        child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5 -
                                                  10,
                                              child: Center(
                                                child: Text('Date',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5 -
                                                  10,
                                              child: Center(
                                                child: Text('Poids',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              child: Center(
                                                child: Text('Client',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              child: Center(
                                                child: Text('Exporateur',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5 -
                                                  5,
                                              child: Center(
                                                child: Text('NCS',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                              )),
                                        ],
                                      ),
                                    ));
                                  }
                                  index -= 1;
                                  if (vent.isEmpty) {
                                    return Container(
                                      width: 69,
                                      height: 69,
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/not-found.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }
                                  return Card(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5 -
                                                  10,
                                              child: Center(
                                                child: Text(
                                                  vent[index]["date"],
                                                  style: TextStyle(
                                                    color: Colors.indigo[400],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5 -
                                                  10,
                                              child: Center(
                                                child: Text(
                                                  vent[index]["poids"],
                                                  style: TextStyle(
                                                    color: Colors.indigo[400],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              child: Center(
                                                child: Text(
                                                  vent[index]["client"],
                                                  style: TextStyle(
                                                    color: Colors.indigo[400],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              child: Center(
                                                child: Text(
                                                  vent[index]["exporateur"],
                                                  style: TextStyle(
                                                    color: Colors.indigo[400],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )),
                                          Padding(padding: EdgeInsets.all(2.0)),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5 -
                                                  5,
                                              child: Center(
                                                child: Text(
                                                  vent[index]["ncs"],
                                                  style: TextStyle(
                                                    color: Colors.indigo[400],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )),
                          ],
                        )),
            ],
          ),
          drawer: AppDrawer(),
        ),
      ),
    );
  }
}
