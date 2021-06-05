import 'package:canpeches/screens/appdrawer.dart';
import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoriqueOperations extends StatefulWidget {
  HistoriqueOperationsController createState() =>
      HistoriqueOperationsController();
}

class HistoriqueOperationsController extends State<HistoriqueOperations> {
  late List historiqueOperation;
  bool visible = true;
  Future getHistoriqueCompte() async {
    var url = globals.globalurl + "/getHistoriqueOperations.php";
    http.Response response = await http.get(Uri.parse(url));
    setState(() {
      historiqueOperation = json.decode(response.body);
      visible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getHistoriqueCompte();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          "Historique des operations des gestion",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
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
                itemCount: historiqueOperation.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 30.0,
                                  color: Colors.indigo[600],
                                ),
                                Padding(padding: EdgeInsets.all(10.0)),
                                Text(
                                  "Email:",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.indigo[400],
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(right: 10.0)),
                                Text(
                                  historiqueOperation[index]["email"],
                                  style: TextStyle(
                                    color: Colors.indigo[400],
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(2.5)),
                            Text(
                              "Action:",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.indigo[400],
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(2.5)),
                            Text(
                              historiqueOperation[index]["action"],
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(2.5)),
                            Text(
                              "Date:",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.indigo[400],
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(2.5)),
                            Text(
                              historiqueOperation[index]["date"],
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )),
                  );
                },
              ),
      ),
      drawer: AppDrawer(),
    );
  }
}
