import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class GetAllExports extends StatefulWidget {
  @override
  GetAllExportsController createState() => GetAllExportsController();
}

class GetAllExportsController extends State<GetAllExports> {
  String? pickedDate;
  late List vents;
  bool visible = true;
  Future getAllExportsPoisson(String? pickeddate) async {
    visible = true;
    var url = globals.globalurl + "/getAllExports.php";
    var data = {'date': pickeddate};
    var response = await http.post(Uri.parse(url), body: json.encode(data));
    setState(() {
      vents = jsonDecode(response.body);
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
    if (globals.isConnected) {
      getAllExportsPoisson("");
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
        title: Text(
          "Les Ventes",
        ),
        actions: [
          IconButton(
            tooltip: "Filtre",
            icon: const Icon(Icons.sort),
            onPressed: () {
              if (globals.isConnected) {
                pickDate(context).then((value) {
                  setState(() {
                    getAllExportsPoisson(pickedDate);
                  });
                });
              }
            },
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
            : globals.isConnected
                ? Container(
                    child: ListView.builder(
                      itemCount: vents.length + 1,
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
                                        MediaQuery.of(context).size.width / 4 -
                                            30,
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
                                    width:
                                        MediaQuery.of(context).size.width / 4 +
                                            10,
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
                                    width:
                                        MediaQuery.of(context).size.width / 4 +
                                            10,
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
                                        MediaQuery.of(context).size.width / 4 -
                                            10,
                                    child: Center(
                                      child: Text('NCS',
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
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Poisson: " + vents[index]["poisson"],
                                      style: TextStyle(
                                        color: Colors.indigo[900],
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                      top: 10,
                                    )),
                                    Text(
                                      "Date: " + vents[index]["date"],
                                      style: TextStyle(
                                        color: Colors.indigo[900],
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(10.0)),
                                    Row(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4 -
                                                30,
                                            child: Center(
                                              child: Text(
                                                vents[index]["poids"],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            )),
                                        Padding(padding: EdgeInsets.all(2.0)),
                                        Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4 +
                                                10,
                                            child: Center(
                                              child: Text(
                                                vents[index]["client"],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            )),
                                        Padding(padding: EdgeInsets.all(2.0)),
                                        Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4 +
                                                10,
                                            child: Center(
                                              child: Text(
                                                vents[index]["exportateur"],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            )),
                                        Padding(padding: EdgeInsets.all(2.0)),
                                        Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4 -
                                                10,
                                            child: Center(
                                              child: Text(
                                                vents[index]["ncs"],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ])),
                        );
                      },
                    ),
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
                                  getAllExportsPoisson("");
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
    );
  }
}
