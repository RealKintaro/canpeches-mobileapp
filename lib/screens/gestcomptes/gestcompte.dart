import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class GestCompte extends StatefulWidget {
  GestCompteController createState() => GestCompteController();
}

class GestCompteController extends State<GestCompte> {
  TextEditingController controllerNom = new TextEditingController(
    text: globals.compteInfo['nom'] == null ? "0" : globals.compteInfo['nom'],
  );
  TextEditingController controllerPrenom = new TextEditingController(
    text: globals.compteInfo['prenom'] == null
        ? "0"
        : globals.compteInfo['prenom'],
  );
  TextEditingController controllerMail = new TextEditingController(
    text:
        globals.compteInfo['email'] == null ? "0" : globals.compteInfo['email'],
  );

  bool isSwitched = globals.compteInfo['etat'] == "1" ? true : false;
  String etat = globals.compteInfo['etat'];
  bool setErrorMail = false,
      setErrorEtat = false,
      setErrorNom = false,
      setErrorPrenom = false;

  Future<String> modifierCompte() async {
    String email, nom, prenom;
    email = controllerMail.text;
    nom = controllerNom.text;
    prenom = controllerPrenom.text;

    var url = globals.globalurl + "/addCompte.php";

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (nom != "") {
      if (prenom != "") {
        if (emailValid) {
          setState(() {
            setErrorMail = false;
          });

          var data = {
            'curruser': globals.userEmail,
            'nom': nom,
            'prenom': prenom,
            'email': email,
            'etat': etat
          };

          var response =
              await http.post(Uri.parse(url), body: json.encode(data));
          var rep = jsonDecode(response.body);
          debugPrint(rep);
          return rep;
        } else {
          setState(() {
            setErrorPrenom = false;
            setErrorMail = true;
          });
        }
      } else {
        setState(() {
          setErrorNom = false;
          setErrorPrenom = true;
        });
      }
    } else {
      setState(() {
        setErrorNom = true;
      });
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          title: Text(
            "Add compte",
          ),
          actions: [],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: globals.background(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 15.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Container(
                        height: 250.0,
                        width: MediaQuery.of(context).size.width - 10,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.only(top: 15.0)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 160.0,
                                    child: TextFormField(
                                      controller: controllerNom,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Nom",
                                          errorText: setErrorNom
                                              ? "Remplire le champ."
                                              : null,
                                          suffixIcon: Icon(
                                            Icons.person,
                                            size: 17,
                                          )),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(right: 5.0)),
                                  Container(
                                    width: 160.0,
                                    child: TextFormField(
                                      controller: controllerPrenom,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Prenom",
                                          errorText: setErrorPrenom
                                              ? "Remplire le champ."
                                              : null,
                                          suffixIcon: Icon(
                                            Icons.person,
                                            size: 17,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 10.0)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 300.0,
                                    child: TextFormField(
                                      controller: controllerMail,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Email',
                                          errorText: setErrorMail
                                              ? "Email invalid."
                                              : null,
                                          suffixIcon: Icon(
                                            Icons.email,
                                            size: 17,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 10.0)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Etat:",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Switch(
                                    value: isSwitched,
                                    onChanged: (value) {
                                      setState(() {
                                        if (isSwitched) {
                                          etat = "0";
                                        } else {
                                          etat = "1";
                                        }
                                        isSwitched = value;
                                        print(etat);
                                      });
                                    },
                                    activeTrackColor: Colors.indigo[700],
                                    activeColor: Colors.lightBlue[700],
                                  ),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: (() {}),
                                      icon: Icon(Icons.person_add),
                                      label: Text("Ajouter"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.indigo[400],
                                        elevation: 5,
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(right: 15)),
                                    ElevatedButton.icon(
                                      onPressed: (() {}),
                                      icon: Icon(Icons.person_remove),
                                      label: Text("Supprimer"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                        elevation: 5,
                                      ),
                                    ),
                                  ])
                            ])),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
