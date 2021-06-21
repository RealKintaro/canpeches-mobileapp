import 'package:canpeches/screens/appdrawer.dart';
import 'package:canpeches/screens/gestcomptes/addcompte.dart';
import 'package:canpeches/screens/gestcomptes/gestcompte.dart';
import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeComptes extends StatefulWidget {
  HomeComptesController createState() => HomeComptesController();
}

class HomeComptesController extends State<HomeComptes> {
  late List comptes;

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
    if (globals.isConnected) {
      getComptes();
    } else {
      setState(() {
        visible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          "Comptes",
        ),
        actions: [],
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
            : globals.isConnected
                ? ListView.builder(
                    itemCount: comptes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          globals.compteInfo = {
                            'id': comptes[index]["id"],
                            'nom': comptes[index]["nom"],
                            'prenom': comptes[index]["prenom"],
                            'email': comptes[index]["email"],
                            'etat': comptes[index]["etat"]
                          };

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GestCompte()),
                          );
                          setState(() {
                            getComptes();
                          });
                        },
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Nom et Prenom: ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(right: 5.0)),
                                      Text(
                                        comptes[index]["nom"],
                                        style: TextStyle(
                                          color: Colors.indigo[400],
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(right: 2.5)),
                                      Text(
                                        comptes[index]["prenom"],
                                        style: TextStyle(
                                          color: Colors.indigo[400],
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.all(3.0)),
                                  Row(
                                    children: [
                                      Text(
                                        "Email:",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(right: 5.0)),
                                      Text(
                                        comptes[index]["email"],
                                        style: TextStyle(
                                          color: Colors.indigo[400],
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.all(3.0)),
                                  Row(
                                    children: [
                                      Text(
                                        "Etat:",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(right: 5.0)),
                                      comptes[index]["etat"] == "1"
                                          ? Text(
                                              "Active",
                                              style: TextStyle(
                                                color: Colors.greenAccent[400],
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : Text(
                                              "Desactive",
                                              style: TextStyle(
                                                color: Colors.red[800],
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Etat:",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(right: 5.0)),
                                      comptes[index]["role"] == "0"
                                          ? Text(
                                              "Admin",
                                              style: TextStyle(
                                                color: Colors.indigo[400],
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : comptes[index]["role"] == "1"
                                              ? Text(
                                                  "SuperAdmin",
                                                  style: TextStyle(
                                                    color: Colors.indigo[400],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              : Text(
                                                  "null",
                                                  style: TextStyle(
                                                    color: Colors.indigo[400],
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        globals.notConnected(),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        ElevatedButton.icon(
                          onPressed: (() {
                            globals.isInternet().then((value) {
                              if (value) {
                                globals.isConnected = true;
                                setState(() {
                                  globals.isConnected = true;
                                  getComptes();
                                });
                              } else {
                                setState(() {
                                  globals.isConnected = false;
                                });
                              }
                            });
                          }),
                          icon: Icon(Icons.refresh),
                          label: Text("Ressayer"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.indigo[400],
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            elevation: 5,
                          ),
                        ),
                      ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (globals.isConnected) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCompte()),
            );
          }
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
