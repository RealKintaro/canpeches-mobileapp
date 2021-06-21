import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:canpeches/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'imagebanner.dart';

class Login extends StatefulWidget {
  LoginController createState() => LoginController();
}

class LoginController extends State<Login> {
  bool setErrorMail = false, setErrorPass = false;
  TextEditingController controllerMail = new TextEditingController();
  TextEditingController controllerPass = new TextEditingController();
  List? lresponse;
  String? type;
  // For CircularProgressIndicator.
  bool visible = false, isConnected = true;

  var url = globals.globalurl + "/loginback.php";

  @override
  void initState() {
    super.initState();
    globals.isInternet().then((value) {
      if (!value) {
        setState(() {
          isConnected = false;
        });
      }
    });
  }

  login(String mail, String pass) async {
    if (isConnected == false) {
      return;
    } else {
      // Showing CircularProgressIndicator.
      setState(() {
        visible = true;
      });

      String email = mail;
      String password = pass;

      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);

      if (emailValid) {
        if (password != "") {
          setState(() {
            setErrorMail = false;
            setErrorPass = false;
          });

          final ip = await Ipify.ipv4(format: Format.TEXT);

          var now = DateTime.now();

          var data = {
            "email": email,
            "password": password,
            "ip": ip,
            "date": now.toString(),
            "type": type
          };

          var response =
              await http.post(Uri.parse(url), body: json.encode(data));

          lresponse = jsonDecode(response.body);
          if (lresponse![0]["res"] == 'Login Matched') {
            // Hiding the CircularProgressIndicator.
            globals.userEmail = email;
            globals.userName = lresponse![0]["firstname"];
            globals.userLastName = lresponse![0]["lastname"];
            globals.userPass = lresponse![0]["token"];
            globals.userId = lresponse![0]["id"];
            if (mounted) {
              Future.delayed(const Duration(milliseconds: 0), () {
                setState(() {
                  visible = false;

                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/home", (route) => false);
                });
              });
            }
          } else {
            // If Email or Password did not Matched.
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
                    Text(
                      lresponse![0]["res"],
                      style: TextStyle(fontSize: 15, color: Colors.red),
                    ),
                    ElevatedButton(
                      child: new Text("OK"),
                      onPressed: () {
                        setState(() {
                          visible = false;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          setState(() {
            visible = false;
            setErrorPass = true;
            setErrorMail = false;
          });
        }
      } else {
        setState(() {
          visible = false;
          setErrorMail = true;
        });
      }
    }
  } //Login func

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(top: 50.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: globals.background(),
          child: isConnected
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageBanner('assets/images/logo.jpg'),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        height: 370.0,
                        width: 350.0,
                        padding: EdgeInsets.all(20.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: visible
                            ? Visibility(
                                visible: visible,
                                child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: CircularProgressIndicator()))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Bonjour',
                                    style: TextStyle(
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: 280.0,
                                    child: TextFormField(
                                      controller: controllerMail,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Email',
                                          errorText: setErrorMail
                                              ? "Email invalide."
                                              : null,
                                          suffixIcon: Icon(
                                            FontAwesomeIcons.envelope,
                                            size: 17,
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 280.0,
                                    child: TextFormField(
                                        controller: controllerPass,
                                        obscureText: _obscureText,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Mot de pass',
                                            errorText: setErrorPass
                                                ? "Remplire le mot de pass."
                                                : null,
                                            suffixIcon: IconButton(
                                                icon: Icon(_obscureText
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                onPressed: () {
                                                  setState(() {
                                                    _obscureText =
                                                        !_obscureText;
                                                  });
                                                }))),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: (() {
                                      globals.isInternet().then((value) {
                                        if (value) {
                                          type = "normal";
                                          login(controllerMail.text.trim(),
                                              controllerPass.text.trim());
                                        } else {
                                          setState(() {
                                            isConnected = false;
                                          });
                                        }
                                      });
                                    }),
                                    icon: Icon(Icons.login),
                                    label: Text("Se connecter"),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.indigo[400],
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      elevation: 5,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: (() {
                                      globals.isInternet().then((value) {
                                        if (value) {
                                          Navigator.pushNamed(
                                                  context, "/qrCode")
                                              .then((value) {
                                            type = "qr";
                                            if (globals.userEmail.trim() !=
                                                    "" &&
                                                globals.userPass.trim() != "") {
                                              login(globals.userEmail.trim(),
                                                  globals.userPass.trim());
                                            } else {
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
                                                                "assets/images/warning.png",
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
                                                          "QR CODE Invalide",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        child: new Text("OK"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            isConnected = false;
                                          });
                                        }
                                      });
                                    }),
                                    icon: Icon(Icons.qr_code_scanner),
                                    label: Text("Qr Code"),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.indigo[400],
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      elevation: 5,
                                    ),
                                  ),
                                ],
                              )),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Container(
                          height: 350.0,
                          width: 350.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ImageBanner('assets/images/no-internet.png'),
                                Padding(padding: EdgeInsets.only(top: 5.0)),
                                Text(
                                  "Veuillez vous connecter à l'internet",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10.0)),
                                ElevatedButton.icon(
                                  onPressed: (() {
                                    globals.isInternet().then((value) {
                                      if (value) {
                                        setState(() {
                                          isConnected = true;
                                        });
                                      } else {
                                        setState(() {
                                          isConnected = false;
                                        });
                                      }
                                    });
                                  }),
                                  icon: Icon(Icons.refresh),
                                  label: Text("Ressayer"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.indigo[400],
                                    shape: const BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    elevation: 5,
                                  ),
                                ),
                              ]))
                    ])),
    ));
  }
}
