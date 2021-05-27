import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:canpeches/globals.dart" as globals;

// Press the Navigation Drawer button to the left of AppBar to show
// a simple Drawer with two items.
class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);
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
    if (!isNewRouteSameAsCurrent) {
      Navigator.pushNamed(context, newRouteName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      accountEmail: Text(
        globals.userName,
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
        drawerHeader,
        ListTile(
          title: Text(
            "Page d'accueil",
          ),
          leading: const Icon(
            Icons.home,
            size: 30,
          ),
          onTap: () {
            newPushNamed(context, "/home");
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
          onTap: () {
            newPushNamed(context, "/homePoissons");
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
          onTap: () {
            newPushNamed(context, "/homeComptes");
          },
        ),
        ExpansionTile(
          title: Text("Import/Export"),
          leading: Icon(
            Icons.import_export_rounded,
            size: 30,
          ),
          children: <Widget>[
            ListTile(
              onTap: () {
                newPushNamed(context, "/getAllImports");
              },
              title: Text("Les Achat"),
              leading: Icon(
                Icons.arrow_downward_rounded,
                size: 30,
              ),
            ),
            ListTile(
              onTap: () {
                newPushNamed(context, "/getAllExports");
              },
              title: Text("Les Vents"),
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
          onTap: () {
            newPushNamed(context, "/getHistoriqueComptes");
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
          onTap: () {
            newPushNamed(context, "/getHistoriqueOperations");
          },
        ),
      ],
    );
    return Drawer(
      child: drawerItems,
    );
  }
}
