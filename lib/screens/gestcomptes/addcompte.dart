import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCompte extends StatefulWidget {
  AddCompteController createState() => AddCompteController();
}

class AddCompteController extends State<AddCompte> {
  TextEditingController controllerNom = new TextEditingController();
  TextEditingController controllerPrenom = new TextEditingController();
  TextEditingController controllerMail = new TextEditingController();
  TextEditingController controllerPass = new TextEditingController();
  bool _obscureText = true,
      setErrorMail = false,
      setErrorPass = false,
      setErrorNom = false,
      setErrorPrenom = false;

  String resaddmsg;

  Future<String> ajouterCompte() async {
    String email, password, nom, prenom;
    email = controllerMail.text;
    password = controllerPass.text;
    nom = controllerNom.text;
    prenom = controllerPrenom.text;

    var url = globals.globalurl + "/addCompte.php";

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (nom != "") {
      if (prenom != "") {
        if (emailValid) {
          if (password != "") {
            var data = {
              'curruser': globals.userEmail,
              'nom': nom,
              'prenom': prenom,
              'email': email,
              'password': password
            };

            var response =
                await http.post(Uri.parse(url), body: json.encode(data));
            var rep = jsonDecode(response.body);
            debugPrint(rep);
            return rep;
          } else {
            setState(() {
              setErrorMail = false;
              setErrorPass = true;
            });
          }
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
            child: Center(
                child: SingleChildScrollView(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: 350.0,
                  height: 370.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Ajouter un compte",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        width: 280.0,
                        child: TextFormField(
                          controller: controllerNom,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nom',
                              errorText:
                                  setErrorNom ? "Remplire le champ." : null,
                              suffixIcon: Icon(
                                Icons.email,
                                size: 17,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        width: 280.0,
                        child: TextFormField(
                          controller: controllerPrenom,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Prenom',
                              errorText:
                                  setErrorPrenom ? "Remplire le champ." : null,
                              suffixIcon: Icon(
                                Icons.email,
                                size: 17,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        width: 280.0,
                        child: TextFormField(
                          controller: controllerMail,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              errorText: setErrorMail ? "Email invalid." : null,
                              suffixIcon: Icon(
                                Icons.email,
                                size: 17,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        width: 280.0,
                        child: TextFormField(
                            controller: controllerPass,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                errorText:
                                    setErrorPass ? "Remplire le champ." : null,
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
                      SizedBox(
                        height: 7,
                      ),
                      ElevatedButton.icon(
                        onPressed: (() {
                          ajouterCompte().then((String value) {
                            resaddmsg = value;
                            if (resaddmsg == "Bien ajouter" ||
                                resaddmsg == "Non ajouter" ||
                                resaddmsg == "Email deja utilise") {
                              Fluttertoast.showToast(
                                  msg: resaddmsg,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.indigo[500],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Navigator.pop(context);
                            }
                          });
                        }),
                        icon: Icon(Icons.person_add),
                        label: Text("Ajouter"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo[400],
                          elevation: 5,
                        ),
                      ),
                    ],
                  )),
            ))));
  }
}
