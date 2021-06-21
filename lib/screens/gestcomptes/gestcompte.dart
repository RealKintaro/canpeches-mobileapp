import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';
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
      setErrorPrenom = false,
      visible = true;

  late String resaddmsg;
  late List compteCounts;
  String countOperationComptes = "0",
      countOperationGestion = "0",
      countConnections = "0";

  Future<String> modifierCompte() async {
    setState(() {
      visible = true;
    });
    String email, nom, prenom;
    email = controllerMail.text;
    nom = controllerNom.text;
    prenom = controllerPrenom.text;

    var url = globals.globalurl + "/editCompte.php";

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
            'id': globals.compteInfo["id"],
            'curruser': globals.userEmail,
            'nom': nom,
            'prenom': prenom,
            'email': email,
            'etat': etat
          };

          var response =
              await http.post(Uri.parse(url), body: json.encode(data));
          var rep = jsonDecode(response.body);
          setState(() {
            visible = false;
          });
          return rep;
        } else {
          setState(() {
            visible = false;
            setErrorPrenom = false;
            setErrorMail = true;
          });
        }
      } else {
        setState(() {
          visible = false;
          setErrorNom = false;
          setErrorPrenom = true;
        });
      }
    } else {
      setState(() {
        visible = false;
        setErrorNom = true;
      });
    }
    return "";
  }

  Future<String> deleteCompte() async {
    setState(() {
      visible = true;
    });
    String email;
    email = controllerMail.text;

    var url = globals.globalurl + "/deleteCompte.php";

    var data = {
      'id': globals.compteInfo["id"],
      'curruser': globals.userEmail,
      'email': email,
    };

    var response = await http.post(Uri.parse(url), body: json.encode(data));
    var rep = jsonDecode(response.body);
    setState(() {
      visible = false;
    });
    return rep;
  }

  Future getCompteCounts() async {
    var url = globals.globalurl + "/CompteCounts.php";
    var data = {
      'email': globals.compteInfo['email'],
    };
    http.Response response =
        await http.post(Uri.parse(url), body: json.encode(data));

    setState(() {
      compteCounts = json.decode(response.body);
      countConnections = compteCounts[0]["countCon"];
      countOperationComptes = compteCounts[0]["countOpCompte"];
      countOperationGestion = compteCounts[0]["countOpGestion"];
      visible = false;
    });
  }

  @override
  void initState() {
    getCompteCounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          title: Text(
            "Modification du compte",
          ),
          actions: [],
        ),
        body: SingleChildScrollView(
            child: Container(
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
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 35.0)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                        "assets/images/operation.png",
                                      ),
                                      fit: BoxFit.fill),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Text(
                                "Operations sur les comptes:",
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
                          countOperationComptes,
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
                                        "assets/images/administration.png",
                                      ),
                                      fit: BoxFit.fill),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Text(
                                "Operations des gestion:",
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
                          countOperationGestion,
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(20.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                            "assets/images/link.png",
                                          ),
                                          fit: BoxFit.fill),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  Text(
                                    "Nombre des connexions:",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400),
                                  )
                                ])),
                        Padding(padding: EdgeInsets.all(5.0)),
                        Text(
                          countConnections,
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 45.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Container(
                              height: 300.0,
                              width: MediaQuery.of(context).size.width - 10,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(top: 30.0)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        Padding(
                                            padding:
                                                EdgeInsets.only(right: 5.0)),
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
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.0)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.0)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            });
                                          },
                                          activeTrackColor: Colors.indigo[700],
                                          activeColor: Colors.lightBlue[700],
                                        ),
                                      ],
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: (() {
                                              BuildContext screenContext =
                                                  context;
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    actions: <Widget>[
                                                      Center(
                                                          child: Container(
                                                        height: 55.0,
                                                        width: 55.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                "assets/images/user.png",
                                                              ),
                                                              fit: BoxFit.fill),
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      )),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  bottom: 5)),
                                                      Center(
                                                        child: Text(
                                                          "Voulez-vous modifier ce compte?",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        child: new Text("OK"),
                                                        onPressed: () {
                                                          modifierCompte().then(
                                                              (String value) {
                                                            resaddmsg = value;
                                                            if (resaddmsg ==
                                                                    "Bien modifier" ||
                                                                resaddmsg ==
                                                                    "Non modifier") {
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      resaddmsg,
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .SNACKBAR,
                                                                  timeInSecForIosWeb:
                                                                      3,
                                                                  backgroundColor:
                                                                      Colors.indigo[
                                                                          500],
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  screenContext);
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }),
                                            icon: Icon(Icons.person_add),
                                            label: Text("Modifier"),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.indigo[400],
                                              elevation: 5,
                                            ),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 15)),
                                          ElevatedButton.icon(
                                            onPressed: (() {
                                              BuildContext screenContext =
                                                  context;
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    actions: <Widget>[
                                                      Center(
                                                          child: Container(
                                                        height: 55.0,
                                                        width: 55.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                "assets/images/delete-account.png",
                                                              ),
                                                              fit: BoxFit.fill),
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      )),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  bottom: 5)),
                                                      Center(
                                                        child: Text(
                                                          "Voulez-vous supprimer ce compte?",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        child: new Text("OK"),
                                                        onPressed: () {
                                                          deleteCompte()
                                                              .then((value) {
                                                            if (value ==
                                                                    "Bien supprimer" ||
                                                                value ==
                                                                    "Non supprimer") {
                                                              Fluttertoast.showToast(
                                                                  msg: value,
                                                                  toastLength: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .SNACKBAR,
                                                                  timeInSecForIosWeb:
                                                                      3,
                                                                  backgroundColor:
                                                                      Colors.indigo[
                                                                          500],
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  screenContext);
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }),
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
        )));
  }
}
