import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  ProfileController createState() => ProfileController();
}

class ProfileController extends State<Profile> {
  TextEditingController controllerNom = new TextEditingController(
    text: globals.userLastName,
  );
  TextEditingController controllerPrenom = new TextEditingController(
    text: globals.userName,
  );
  TextEditingController controllerMail = new TextEditingController(
    text: globals.userEmail,
  );
  TextEditingController controllerOldPass = new TextEditingController();
  TextEditingController controllerNewPass = new TextEditingController();

  bool _obscureText1 = true, _obscureText2 = true;

  bool setErrorMail = false,
      setErrorNom = false,
      setErrorPrenom = false,
      setErrorOldPass = false,
      setErrorNewPass = false,
      visible = false;

  late String errorMsg;

  Future modifierCompte() async {
    setState(() {
      visible = true;
    });
    String email, nom, prenom, oldpass, newpass;
    email = controllerMail.text;
    nom = controllerNom.text;
    prenom = controllerPrenom.text;
    oldpass = controllerOldPass.text.trim();
    newpass = controllerNewPass.text.trim();

    var url = globals.globalurl + "/editProfile.php";

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    bool passwordValid = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(newpass);

    if (nom != "") {
      if (prenom != "") {
        if (emailValid) {
          if (oldpass != "") {
            if (passwordValid) {
              setState(() {
                setErrorPrenom = false;
                setErrorMail = false;
                setErrorNom = false;
                setErrorOldPass = false;
                setErrorNewPass = false;
              });

              var data = {
                "id": globals.userId,
                "nom": nom,
                "prenom": prenom,
                "email": email,
                "oldpass": oldpass,
                "newpass": newpass
              };
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    actions: <Widget>[
                      Center(
                          child: Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/images/warning.png",
                              ),
                              fit: BoxFit.fill),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )),
                      Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                      Center(
                        child: Text(
                          "Voulez-vous modifier votre profile?",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      TextButton(
                        child: new Text("OK"),
                        onPressed: () async {
                          var response = await http.post(Uri.parse(url),
                              body: json.encode(data));
                          var rep = jsonDecode(response.body);

                          controllerOldPass.clear();
                          controllerNewPass.clear();
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: rep.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.indigo[500],
                              textColor: Colors.white,
                              fontSize: 16.0);
                          setState(() {
                            visible = false;
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              setState(() {
                visible = false;
                setErrorOldPass = false;
                errorMsg =
                    "Le mot de passe doit contenir 8 caractères,\n au moins 1 majuscule et 1 chiffre!";
                setErrorNewPass = true;
              });
            }
          } else {
            setState(() {
              visible = false;
              setErrorOldPass = true;
              errorMsg = "Remplire le champ!";
              setErrorMail =
                  setErrorNewPass = setErrorNom = setErrorPrenom = false;
            });
          }
        } else {
          setState(() {
            visible = false;
            setErrorOldPass =
                setErrorNewPass = setErrorNom = setErrorPrenom = false;
            errorMsg = "E-mail invalide!";
            setErrorMail = true;
          });
        }
      } else {
        setState(() {
          visible = false;
          setErrorMail =
              setErrorNewPass = setErrorOldPass = setErrorNom = false;
          errorMsg = "Remplire le champ!";
          setErrorPrenom = true;
        });
      }
    } else {
      setState(() {
        visible = false;
        setErrorMail =
            setErrorNewPass = setErrorOldPass = setErrorPrenom = false;
        errorMsg = "Remplire le champ!";
        setErrorNom = true;
      });
    }
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
            "Modification du profile",
          ),
          actions: [],
        ),
        body: SingleChildScrollView(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 80,
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
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 34.0,
                        ),
                        Container(
                          constraints: BoxConstraints.expand(
                              height: 150.0, width: 150.0),
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Image.asset(
                            "assets/images/businessman.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              child: Container(
                                  height: 400.0,
                                  width: MediaQuery.of(context).size.width - 10,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.only(top: 30.0)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 160.0,
                                              child: TextFormField(
                                                controller: controllerNom,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: "Nom",
                                                    errorText: setErrorNom
                                                        ? errorMsg
                                                        : null,
                                                    suffixIcon: Icon(
                                                      Icons.person,
                                                      size: 17,
                                                    )),
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    right: 5.0)),
                                            Container(
                                              width: 160.0,
                                              child: TextFormField(
                                                controller: controllerPrenom,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: "Prenom",
                                                    errorText: setErrorPrenom
                                                        ? errorMsg
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
                                            padding:
                                                EdgeInsets.only(top: 10.0)),
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
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Email',
                                                    errorText: setErrorMail
                                                        ? errorMsg
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
                                            padding:
                                                EdgeInsets.only(top: 10.0)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 300.0,
                                              child: TextFormField(
                                                controller: controllerOldPass,
                                                obscureText: _obscureText2,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Mot de pass actuel',
                                                    errorText: setErrorOldPass
                                                        ? errorMsg
                                                        : null,
                                                    suffixIcon: IconButton(
                                                        icon: Icon(_obscureText2
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off),
                                                        onPressed: () {
                                                          setState(() {
                                                            _obscureText2 =
                                                                !_obscureText2;
                                                          });
                                                        })),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(top: 10.0)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 300.0,
                                              child: TextFormField(
                                                controller: controllerNewPass,
                                                obscureText: _obscureText1,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Nouveau mot de passe',
                                                    errorText: setErrorNewPass
                                                        ? errorMsg
                                                        : null,
                                                    suffixIcon: IconButton(
                                                        icon: Icon(_obscureText1
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off),
                                                        onPressed: () {
                                                          setState(() {
                                                            _obscureText1 =
                                                                !_obscureText1;
                                                          });
                                                        })),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(top: 10.0)),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: (() {
                                                  modifierCompte();
                                                }),
                                                icon: Icon(Icons.person_add),
                                                label: Text("Modifier"),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.indigo[400],
                                                  elevation: 5,
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 15)),
                                            ])
                                      ])),
                            )
                          ],
                        ),
                      ],
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
                                  setState(() {
                                    globals.isConnected = true;
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
        )));
  }
}
