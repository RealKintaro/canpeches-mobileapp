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

  late String resaddmsg;

  Future<String> modifierCompte() async {
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

              var response =
                  await http.post(Uri.parse(url), body: json.encode(data));
              var rep = jsonDecode(response.body);
              setState(() {
                visible = false;
              });
              controllerOldPass.clear();
              controllerNewPass.clear();
              return rep;
            } else {
              setState(() {
                visible = false;
                setErrorOldPass = false;
                setErrorNewPass = true;
              });
              return "";
            }
          } else {
            setState(() {
              visible = false;
              setErrorOldPass = true;
              setErrorMail = false;
            });
            return "";
          }
        } else {
          setState(() {
            visible = false;
            setErrorPrenom = false;
            setErrorMail = true;
          });
          return "";
        }
      } else {
        setState(() {
          visible = false;
          setErrorNom = false;
          setErrorPrenom = true;
        });
        return "";
      }
    } else {
      setState(() {
        visible = false;
        setErrorNom = true;
      });
    }
    return "";
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 45.0,
                    ),
                    Container(
                      constraints:
                          BoxConstraints.expand(height: 150.0, width: 150.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 300.0,
                                          child: TextFormField(
                                            controller: controllerOldPass,
                                            obscureText: _obscureText2,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Mot de pass actuel',
                                                errorText: setErrorOldPass
                                                    ? "Mot de pass invalid."
                                                    : null,
                                                suffixIcon: IconButton(
                                                    icon: Icon(_obscureText2
                                                        ? Icons.visibility
                                                        : Icons.visibility_off),
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
                                            controller: controllerNewPass,
                                            obscureText: _obscureText1,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText:
                                                    'Nouveau mot de passe',
                                                errorText: setErrorNewPass
                                                    ? "Mot de pass invalid."
                                                    : null,
                                                suffixIcon: IconButton(
                                                    icon: Icon(_obscureText1
                                                        ? Icons.visibility
                                                        : Icons.visibility_off),
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
                                        padding: EdgeInsets.only(top: 10.0)),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: (() {
                                              modifierCompte()
                                                  .then((String value) {
                                                resaddmsg = value;
                                                if (resaddmsg ==
                                                        "Bien modifier" ||
                                                    resaddmsg ==
                                                        "Non modifier" ||
                                                    resaddmsg ==
                                                        "Mot de pass actuel invalide") {
                                                  Fluttertoast.showToast(
                                                      msg: resaddmsg,
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.SNACKBAR,
                                                      timeInSecForIosWeb: 3,
                                                      backgroundColor:
                                                          Colors.indigo[500],
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                }
                                              });
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
