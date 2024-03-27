import 'package:flutter/material.dart';
import 'package:mypod/widgets/PopupMenu/popup_about.dart';
import 'package:mypod/widgets/PopupMenu/popup_basal_temp.dart';
import 'package:mypod/widgets/PopupMenu/popup_historique.dart';
import 'package:mypod/widgets/PopupMenu/popup_infos_perso.dart';
import 'package:mypod/widgets/PopupMenu/popup_pod.dart';

class MyPopupMenu extends StatelessWidget {
  const MyPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'menu_basal_temp') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const BasalTempPage(), // Naviguer vers BasalTempPage
            ),
          );
        } else if (value == 'menu_infos_perso') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const InfosPerso(), // Naviguer vers InfoPersoPage
            ),
          );
        } else if (value == 'menu_pod') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PodPage(), // Naviguer vers PodPage
            ),
          );
        } else if (value == 'menu_historique') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const Historique(), // Naviguer vers Historique
            ),
          );
        } else if (value == 'menu_about') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const PopupAbout(), // Naviguer vers Historique
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'menu_infos_perso',
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Informations Personnelles'),
            ),
          ),
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
          const PopupMenuItem<String>(
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
          const PopupMenuItem<String>(
            value: 'menu_about',
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('À propos'),
            ),
          ),
        ];
      },
    );
  }
}
