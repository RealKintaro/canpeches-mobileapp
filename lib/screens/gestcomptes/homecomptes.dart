import 'package:canpeches/screens/appdrawer.dart';
import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeComptes extends StatefulWidget {
  HomeComptesController createState() => HomeComptesController();
}

class HomeComptesController extends State<HomeComptes> {
  bool _obscureText = true;
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
                itemCount: comptes == null ? 0 : comptes.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onLongPress: () {
                      globals.compteid = comptes[index]["id"];
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
          popUp();
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      drawer: AppDrawer(),
    );
  }

  popUp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 300.0,
                child: Stack(
                  children: <Widget>[
                    Form(
                        child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Center(
                            child: Text("Ajouter un compte"),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nom',
                                  suffixIcon: Icon(
                                    Icons.email,
                                    size: 17,
                                  )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Prenom',
                                  suffixIcon: Icon(
                                    Icons.email,
                                    size: 17,
                                  )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                  suffixIcon: Icon(
                                    Icons.email,
                                    size: 17,
                                  )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: TextFormField(
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    suffixIcon: IconButton(
                                        icon: Icon(_obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        }))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton.icon(
                              onPressed: (() {}),
                              icon: Icon(Icons.person_add),
                              label: Text("Ajouter"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.indigo[400],
                                shape: const BeveledRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                elevation: 5,
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                  ],
                )),
          );
        });
  }
}
