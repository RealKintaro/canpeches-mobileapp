import 'package:canpeches/screens/appdrawer.dart';
import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeComptes extends StatefulWidget {
  HomeComptesController createState() => HomeComptesController();
}

class HomeComptesController extends State<HomeComptes> {
  List comptes;
  bool visible = true;
  Future getComptes() async {
    var url = globals.globalurl + "/getComptes.php";
    http.Response response = await http.get(Uri.parse(url));
    setState(() {
      comptes = json.decode(response.body);
      visible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getComptes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          "Comptes",
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
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ))))
            : ListView.builder(
                itemCount: comptes == null ? 1 : comptes.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 4 - 10,
                              child: Center(
                                child: Text("NOM",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 4 - 10,
                              child: Center(
                                child: Text("PRENOM",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 4 + 40,
                              child: Center(
                                child: Text("EMAIL",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 4 - 30,
                              child: Center(
                                child: Text("ETAT",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  index -= 1;
                  return GestureDetector(
                    onTap: () {
                      globals.compteid = comptes[index]["id"];
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 4 - 23,
                              child: Text(
                                comptes[index]["nom"],
                                style: TextStyle(
                                  color: Colors.indigo[400],
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                              width: MediaQuery.of(context).size.width / 4 - 23,
                              child: Text(
                                comptes[index]["prenom"],
                                style: TextStyle(
                                  color: Colors.indigo[400],
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                              width: MediaQuery.of(context).size.width / 4 + 55,
                              child: Text(
                                comptes[index]["email"],
                                style: TextStyle(
                                  color: Colors.indigo[400],
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                                width:
                                    MediaQuery.of(context).size.width / 4 - 50,
                                child: Center(
                                  child: comptes[index]["etat"] == "1"
                                      ? Text(
                                          "Act",
                                          style: TextStyle(
                                            color: Colors.greenAccent[400],
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      : Text(
                                          "Des",
                                          style: TextStyle(
                                            color: Colors.red[800],
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      drawer: AppDrawer(),
    );
  }
}
