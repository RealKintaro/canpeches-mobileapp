import 'package:canpeches/screens/appdrawer.dart';
import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class HistoriqueConnection extends StatefulWidget {
  HistoriqueConnectionController createState() =>
      HistoriqueConnectionController();
}

class HistoriqueConnectionController extends State<HistoriqueConnection> {
  String? pickedDate;
  late List historiqueConnection;
  bool visible = true;
  Future getHistoriqueCompte(String? pickeddate) async {
    visible = true;
    var url = globals.globalurl + "/getHistoriqueConnections.php";
    var data = {'date': pickeddate};
    http.Response response =
        await http.post(Uri.parse(url), body: json.encode(data));
    setState(() {
      historiqueConnection = json.decode(response.body);
      visible = false;
    });
  }

  Future pickDate(BuildContext context) async {
    var outputFormat = DateFormat('yyyy-MM-dd');
    final initDate = DateTime.now();
    final pickeddate = await showDatePicker(
        context: context,
        initialDate: initDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (pickeddate == null) return;
    setState(() {
      pickedDate = outputFormat.format(pickeddate).toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getHistoriqueCompte("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          "Historique des connections",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Filtre",
            icon: const Icon(Icons.sort),
            onPressed: () {
              pickDate(context).then((value) {
                setState(() {
                  getHistoriqueCompte(pickedDate);
                });
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
            : ListView.builder(
                itemCount: historiqueConnection.length,
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
                                  historiqueConnection[index]["email"],
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
                              "Date:",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.indigo[400],
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(2.5)),
                            Text(
                              historiqueConnection[index]["date"],
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
