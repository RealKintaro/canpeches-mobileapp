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

  late String resaddmsg;
  String? _selectedRole;
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
    bool passwordValid = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(password);

    if (nom != "") {
      if (prenom != "") {
        if (emailValid) {
          if (passwordValid) {
            var data = {
              'curruser': globals.userEmail,
              'nom': nom,
              'prenom': prenom,
              'email': email,
              'password': password,
              'role': _selectedRole == "Admin"
                  ? "0"
                  : _selectedRole == "SuperAdmin"
                      ? "1"
                      : "99"
            };

            var response =
                await http.post(Uri.parse(url), body: json.encode(data));
            var rep = jsonDecode(response.body);
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
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          title: Text(
            "Ajout du compte",
          ),
          actions: [],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: globals.background(),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  constraints:
                      BoxConstraints.expand(height: 150.0, width: 150.0),
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Image.asset(
                    "assets/images/add-user.png",
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 350.0,
                    height: 450.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
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
                          height: 10.0,
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
                                errorText: setErrorPrenom
                                    ? "Remplire le champ."
                                    : null,
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
                                errorText:
                                    setErrorMail ? "Email invalid." : null,
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
                                  errorText: setErrorPass
                                      ? "Remplire le champ."
                                      : null,
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
                        DropdownButton(
                          hint: Text('Role'),
                          value: _selectedRole,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRole = newValue;
                            });
                          },
                          items: <String>['Admin', 'SuperAdmin']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: new Container(
                                    width: 150.0,
                                    child: Center(
                                      child: Text(value,
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    )));
                          }).toList(),
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
              ],
            ))));
  }
}
