import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:canpeches/globals.dart' as globals;
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeGen extends StatefulWidget {
  @override
  _QrCodeGenController createState() => _QrCodeGenController();
}

class _QrCodeGenController extends State<QrCodeGen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          "Qr Code",
        ),
        actions: [],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: globals.background(),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Votre QR CODE:",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26.0,
                  fontWeight: FontWeight.w700),
            ),
            Padding(padding: EdgeInsets.all(15.0)),
            QrImage(
              backgroundColor: Colors.white,
              data: json.encode(
                  {"email": globals.userEmail, "mdp": globals.userPass}),
              version: QrVersions.auto,
              size: 250.0,
            ),
          ],
        )),
      ),
    );
  }
}
