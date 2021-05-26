import 'package:canpeches/screens/appdrawer.dart';
import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetAllExports extends StatefulWidget {
  @override
  GetAllExportsController createState() => GetAllExportsController();
}

class GetAllExportsController extends State<GetAllExports> {
  List vents;
  bool visible = true;
  Future getAllImportPoisson() async {
    var url = globals.globalurl + "/getAllExports.php";
    var data = {'id': globals.poissonid};
    var response = await http.post(Uri.parse(url), body: json.encode(data));
    setState(() {
      vents = jsonDecode(response.body);
      visible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllImportPoisson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          "Les Vents",
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
            : Expanded(
                child: Container(
                child: ListView.builder(
                  itemCount: vents == null ? 1 : vents.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      // return the header
                      return Card(
                          child: Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Row(
                          children: [
                            Container(
                                width:
                                    MediaQuery.of(context).size.width / 6 - 10,
                                child: Center(
                                  child: Text('Date',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                )),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                                width:
                                    MediaQuery.of(context).size.width / 6 - 10,
                                child: Center(
                                  child: Text('Poids',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                )),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                                width: MediaQuery.of(context).size.width / 6,
                                child: Center(
                                  child: Text('Client',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                )),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                                width: MediaQuery.of(context).size.width / 6,
                                child: Center(
                                  child: Text('Exporateur',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                )),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                                width:
                                    MediaQuery.of(context).size.width / 6 - 5,
                                child: Center(
                                  child: Text('NCS',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                )),
                            Container(
                                width:
                                    MediaQuery.of(context).size.width / 6 - 5,
                                child: Center(
                                  child: Text('Poisson',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                )),
                          ],
                        ),
                      ));
                    }
                    index -= 1;
                    if (vents.isEmpty) {
                      return Container(
                        width: 69,
                        height: 69,
                        child: Center(
                          child: Image.asset(
                            "assets/images/not-found.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Row(
                          children: [
                            Container(
                                width:
                                    MediaQuery.of(context).size.width / 6 - 10,
                                child: Center(
                                  child: Text(
                                    vents[index]["date"],
                                    style: TextStyle(
                                      color: Colors.indigo[400],
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                                width:
                                    MediaQuery.of(context).size.width / 6 - 10,
                                child: Center(
                                  child: Text(
                                    vents[index]["poids"],
                                    style: TextStyle(
                                      color: Colors.indigo[400],
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                                width: MediaQuery.of(context).size.width / 6,
                                child: Center(
                                  child: Text(
                                    vents[index]["client"],
                                    style: TextStyle(
                                      color: Colors.indigo[400],
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                                width: MediaQuery.of(context).size.width / 6,
                                child: Center(
                                  child: Text(
                                    vents[index]["exportateur"],
                                    style: TextStyle(
                                      color: Colors.indigo[400],
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                                width:
                                    MediaQuery.of(context).size.width / 6 - 5,
                                child: Center(
                                  child: Text(
                                    vents[index]["ncs"],
                                    style: TextStyle(
                                      color: Colors.indigo[400],
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )),
                            Container(
                                width:
                                    MediaQuery.of(context).size.width / 6 - 5,
                                child: Center(
                                  child: Text(
                                    vents[index]["poisson"],
                                    style: TextStyle(
                                      color: Colors.indigo[400],
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )),
      ),
      drawer: AppDrawer(),
    );
  }
}
