import 'package:canpeches/screens/appdrawer.dart';
import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePoissons extends StatefulWidget {
  HomePoissonsController createState() => HomePoissonsController();
}

class HomePoissonsController extends State<HomePoissons> {
  TextEditingController controllerMail = new TextEditingController();
  bool setErrorMail = false;
  String? resaddmsg;
  String? countvents;
  late List poissons;
  bool visible = true, isSearching = false;
  Future getPoissons(String? poisson) async {
    setState(() {
      visible = true;
    });
    var url = globals.globalurl + "/getPoissons.php";
    var data = {'poisson': poisson};
    http.Response response =
        await http.post(Uri.parse(url), body: json.encode(data));
    setState(() {
      poissons = json.decode(response.body);
      visible = false;
    });
  }

  Future<String?> sendMail(String? mail) async {
    setState(() {
      visible = true;
    });
    var url = globals.globalurl + "/SendListEmail.php";
    var data = {"curruser": globals.userEmail, 'email': mail};
    http.Response response =
        await http.post(Uri.parse(url), body: json.encode(data));
    setState(() {
      visible = false;
      return json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    if (globals.isConnected) {
      getPoissons("");
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
        title: !isSearching
            ? Text(
                "Nos poissons",
              )
            : TextField(
                style: TextStyle(color: Colors.white),
                onChanged: (string) {
                  if (globals.isConnected) {
                    setState(() {
                      getPoissons(string);
                    });
                  }
                },
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Recherche",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        actions: [
          /*IconButton(
            tooltip: "Mail",
            icon: const Icon(Icons.mail),
            onPressed: () {
              setState(() {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: new Text("ENVOI EMAIL"),
                      actions: <Widget>[
                        TextField(
                          controller: controllerMail,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              errorText: setErrorMail ? "Email invalid." : null,
                              icon: Icon(
                                Icons.mail,
                                color: Colors.black,
                              ),
                              hintText: "EMAIL",
                              hintStyle: TextStyle(color: Colors.black)),
                        ),
                        TextButton(
                          child: new Text("OK"),
                          onPressed: () {
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(controllerMail.text);
                            if (emailValid) {
                              sendMail(controllerMail.text).then((value) {
                                resaddmsg = value!;
                                if (resaddmsg == "BIEN ENVOYEZ" ||
                                    resaddmsg == "Non ENVOYEZ" ||
                                    resaddmsg ==
                                        "Veuillez saisir un Email , Svp !") {}
                              });
                              setState(() {
                                visible = false;
                              });
                            } else {
                              setState(() {
                                visible = false;
                                setErrorMail = true;
                              });
                            }
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                                msg: resaddmsg!,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.indigo[500],
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                        ),
                      ],
                    );
                  },
                );
              });
            },
          ),*/
          !isSearching
              ? IconButton(
                  tooltip: "Recherche",
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                )
              : IconButton(
                  tooltip: "Cancel",
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                    });
                  },
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
            : globals.isConnected
                ? ListView.builder(
                    itemCount: poissons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          globals.poissonid = poissons[index]["id"];
                          Navigator.pushNamed(context, "/gestPoisson");
                        },
                        child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ImageIcon(
                                        AssetImage("assets/images/fish3.png"),
                                        color: Colors.indigo[600],
                                        size: 30,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              5.0, 20.0, 5.0, 20.0)),
                                      Text(
                                        poissons[index]["name"],
                                        style: TextStyle(
                                          color: Colors.indigo[400],
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Nombre des Ventes: " +
                                            poissons[index]["countvents"]!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(right: 20)),
                                      Text(
                                        "Nombre des achats: " +
                                            poissons[index]["countachats"]!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )
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
                                  getPoissons("");
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
      drawer: AppDrawer(),
    );
  }
}
