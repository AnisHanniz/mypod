import 'package:flutter/material.dart';
import 'package:mypod/widgets/PopupMenu/basal_temp_page.dart';
import 'package:mypod/widgets/PopupMenu/pod_page.dart';

class MyPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Action à effectuer lorsque le menu est sélectionné
        if (value == 'menu_basal_temp') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BasalTempPage(), // Naviguer vers BasalTempPage
            ),
          );
        } else if (value == 'menu_pod') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PodPage(), // Naviguer vers PodPage
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'menu_basal_temp',
            child: ListTile(
              leading: Icon(Icons.lock_clock),
              title: Text('Définir Basal Temporaire'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'menu_pod',
            child: ListTile(
              leading: Icon(Icons.smartphone),
              title: Text('Pod'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'menu_suspendre_insuline',
            child: ListTile(
              leading: Icon(Icons.stop),
              title: Text('Suspendre Admin. Insuline'),
            ),
          ),
          PopupMenuItem<String>(
            value: 'menu_prog_basaux',
            child: ListTile(
              leading: Icon(Icons.schema_rounded),
              title: Text('Programmes Basaux'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'menu_historique',
            child: ListTile(
              leading: Icon(Icons.history),
              title: Text("Historique d'injections"),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'menu_rappels',
            child: ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Rappels'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'menu_reglages',
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Réglages'),
            ),
          ),
        ];
      },
    );
  }
}
