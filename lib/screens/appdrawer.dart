import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:canpeches/globals.dart" as globals;

// Press the Navigation Drawer button to the left of AppBar to show
// a simple Drawer with two items.
class AppDrawer extends StatefulWidget {
  AppDrawerController createState() => AppDrawerController();
}

class AppDrawerController extends State<AppDrawer> {
  newPushNamed(BuildContext context, String route) {
    final newRouteName = route;
    bool isNewRouteSameAsCurrent = false;
    Navigator.pop(context);
    Navigator.popUntil(context, (route) {
      if (route.settings.name == newRouteName) {
        isNewRouteSameAsCurrent = true;
      }
      return true;
    });
    globals.isInternet().then((value) async {
      if (value) {
        setState(() {
          globals.isConnected = true;
        });
        if (!isNewRouteSameAsCurrent) {
          Navigator.pushNamed(context, newRouteName);
        }
      } else {
        setState(() {
          globals.isConnected = false;
        });
        if (!isNewRouteSameAsCurrent) {
          Navigator.pushNamed(context, newRouteName);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      accountEmail: Text(
        globals.userLastName + " " + globals.userName,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      accountName: Text(
        globals.userEmail,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      currentAccountPicture: CircleAvatar(
          child: Container(
        height: 69.0,
        width: 69.0,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/images/profile.png",
              ),
              fit: BoxFit.fill),
          color: Colors.transparent,
        ),
      )),
      decoration: BoxDecoration(color: Colors.indigo[700]),
    );
    final drawerItems = ListView(
      children: [
        GestureDetector(
          child: drawerHeader,
          onTap: () async {
            await newPushNamed(context, "/profile");
          },
        ),
        ListTile(
          title: Text(
            "Page d'accueil",
          ),
          leading: const Icon(
            Icons.home,
            size: 30,
          ),
          onTap: () async {
            globals.isInternet().then((value) async {
              if (value) {
                setState(() {
                  globals.isConnected = true;
                });
                await Navigator.of(context)
                    .pushNamedAndRemoveUntil("/home", (route) => false);
              } else {
                setState(() {
                  globals.isConnected = false;
                });
                await Navigator.of(context)
                    .pushNamedAndRemoveUntil("/home", (route) => false);
              }
            });
          },
        ),
        Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 10.0)),
            Text(
              "GESTIONS:",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.indigo[500],
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        ListTile(
          title: Text(
            "Gestion Poissons",
          ),
          leading: const ImageIcon(
            AssetImage("assets/images/fish3.png"),
            size: 30,
          ),
          onTap: () async {
            await newPushNamed(context, "/homePoissons");
          },
        ),
        ListTile(
          title: Text(
            "Gestion Comptes",
          ),
          leading: const Icon(
            Icons.person,
            size: 30,
          ),
          onTap: () async {
            await newPushNamed(context, "/homeComptes");
          },
        ),
        ExpansionTile(
          title: Text("Achats/Ventes"),
          leading: Icon(
            Icons.import_export_rounded,
            size: 30,
          ),
          children: <Widget>[
            ListTile(
              onTap: () async {
                await newPushNamed(context, "/getAllImports");
              },
              title: Text("Les Achat"),
              leading: Icon(
                Icons.arrow_downward_rounded,
                size: 30,
              ),
            ),
            ListTile(
              onTap: () async {
                await newPushNamed(context, "/getAllExports");
              },
              title: Text("Les Ventes"),
              leading: Icon(
                Icons.arrow_upward_rounded,
                size: 30,
              ),
            )
          ],
        ),
        Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 10.0)),
            Text(
              "HISTORIQUES:",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.indigo[500],
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        ListTile(
          title: Text(
            "Opérations Comptes",
          ),
          leading: const ImageIcon(
            AssetImage("assets/images/profile_op.png"),
            size: 30,
          ),
          onTap: () async {
            await newPushNamed(context, "/getHistoriqueComptes");
          },
        ),
        ListTile(
          title: Text(
            "Opérations Gestions",
          ),
          leading: const ImageIcon(
            AssetImage("assets/images/settings.png"),
            size: 30,
          ),
          onTap: () async {
            await newPushNamed(context, "/getHistoriqueOperations");
          },
        ),
        ListTile(
          title: Text("Historique des connections"),
          leading: const Icon(
            Icons.history,
            size: 30,
          ),
          onTap: () async {
            await newPushNamed(context, '/getHistoriqueConnections');
          },
        ),
        Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 10.0)),
            Text(
              "Autre:",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.indigo[500],
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        ListTile(
          title: Text("Qr code"),
          leading: const Icon(
            Icons.qr_code,
            size: 30,
          ),
          onTap: () async {
            await newPushNamed(context, '/qrGen');
          },
        )
      ],
    );
    return Drawer(
      child: drawerItems,
    );
  }
}
