import 'package:canpeches/screens/appdrawer.dart';
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
            : ListView.builder(
                itemCount: comptes.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      globals.compteInfo = {
                        'id': comptes[index]["id"],
                        'nom': comptes[index]["nom"],
                        'prenom': comptes[index]["prenom"],
                        'email': comptes[index]["email"],
                        'etat': comptes[index]["etat"]
                      };
                      Navigator.pushReplacementNamed(context, '/gestCompte');
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
                                  Padding(padding: EdgeInsets.only(right: 5.0)),
                                  Text(
                                    comptes[index]["nom"],
                                    style: TextStyle(
                                      color: Colors.indigo[400],
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(right: 2.5)),
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
                                  Padding(padding: EdgeInsets.only(right: 5.0)),
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
                                  Padding(padding: EdgeInsets.only(right: 5.0)),
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
                            ],
                          )),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/addCompte");
          setState(() {
            getComptes();
          });
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
