import 'package:canpeches/screens/appdrawer.dart';
import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePoissons extends StatefulWidget {
  HomePoissonsController createState() => HomePoissonsController();
}

class HomePoissonsController extends State<HomePoissons> {
  String? countvents;
  late List poissons;
  bool visible = true;
  Future getPoissons() async {
    var url = globals.globalurl + "/getPoissons.php";
    http.Response response = await http.get(Uri.parse(url));
    setState(() {
      poissons = json.decode(response.body);
      visible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPoissons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          "Nos poissons",
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
                                    "Nombre des vents: " +
                                        poissons[index]["countvents"]!,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(right: 20)),
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
              ),
      ),
      drawer: AppDrawer(),
    );
  }
}
