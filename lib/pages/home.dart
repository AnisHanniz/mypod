import 'dart:async';

import 'package:flutter_svg/svg.dart';
import 'package:mypod/models/bluetooth_manager.dart';
import 'package:mypod/models/infos_pod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mypod/pages/BasalProfile.dart';

class HomePage extends StatefulWidget {
  final BluetoothManager bluetoothManager;

  HomePage({Key? key, required this.bluetoothManager}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<InfosPod> infos = [];
  double insulinRemaining = 200.0;
  BasalProfile basalProfile =
      BasalProfile([]); // Initialise ici la variable basalProfile

  double calculateBasalInsulinToAdminister() {
    final now = TimeOfDay.now();
    final basalRate = basalProfile
        .calculateBasalInsulinForTime(now); // Accède à basalProfile ici
    return basalRate;
  }

  // Fonction pour administrer un bolus
  void administerBolus() {
    // Ici, vous pouvez définir la logique pour le bolus
    // Par exemple, récupérer la quantité de bolus à administrer

    double bolusAmount = 5.0; // Remplacez ceci par la valeur réelle du bolus
    // Envoyer la commande de bolus via BluetoothManager
    widget.bluetoothManager.administerBolus(bolusAmount);

    // Reducing the remaining insulin after administering the bolus
    setState(() {
      insulinRemaining -= bolusAmount;
    });
  }

  // Méthode pour afficher un dialogue pour saisir la quantité du bolus
  Future<void> showBolusInputDialog() async {
    double bolusAmount = 0.0;
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Entrez la quantité du bolus'),
          content: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              bolusAmount = double.tryParse(value) ?? 0.0;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(bolusAmount);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null) {
        if (value <= 0) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Valeur invalide'),
                content: Text('Veuillez entrer une quantité de bolus valide.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (insulinRemaining >= value) {
          // Assez d'insuline, administrez le bolus
          widget.bluetoothManager.administerBolus(value);
          setState(() {
            insulinRemaining -= value;
          });
        } else {
          // Pas assez d'insuline restante
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Pas assez d\'insuline restante'),
                content: Text(
                    'L\'insuline restante n\'est pas suffisante pour ce bolus.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  void _getInfosPod() {
    infos = InfosPod.getInfosPod();
  }

  @override
  void initState() {
    super.initState();
    _getInfosPod();
    const interval = Duration(minutes: 5); // Changer l'intervalle si nécessaire
    Timer.periodic(interval, (Timer t) {
      final basalInsulin = calculateBasalInsulinToAdminister();
      widget.bluetoothManager.administerBasalInsulin(basalInsulin);
      setState(() {
        insulinRemaining -= basalInsulin;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var MONTHS = [
      "Jan",
      "Fev",
      "Mar",
      "Avr",
      "Mai",
      "Jun",
      "Jul",
      "Aou",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return Scaffold(
      appBar: appBar(MONTHS),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(25),
            child: Center(
              child: Text(
                'myPod',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            height: 170,
            color: const Color.fromARGB(255, 255, 255, 255),
            child: ListView.separated(
              itemCount: infos.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              separatorBuilder: (context, index) => const SizedBox(width: 25),
              itemBuilder: (context, index) {
                InfosPod info = infos[index];
                return Column(
                  children: [
                    Container(
                      width: 300,
                      height: 139,
                      decoration: BoxDecoration(
                        color: info.boxColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          info.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      info.text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            height: 185,
            color: const Color.fromARGB(255, 255, 255, 255),
            child: ListView.separated(
              itemCount: 1,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              separatorBuilder: (context, index) => const SizedBox(width: 25),
              itemBuilder: (context, index) {
                InfosPod info = infos[index];
                return Column(
                  children: [
                    Container(
                      width: 128,
                      height: 120,
                      decoration: BoxDecoration(
                        color: info.boxColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Dernier Bolus',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
          const Spacer(),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(20),
            child: InkWell(
              onTap: () {
                showBolusInputDialog();
                // Action à effectuer lorsque le bouton est cliqué
              },
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.lab_flask_solid,
                      color: Colors.white,
                      size: 30,
                    ),
                    Text(
                      'Bolus',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(), // Utilisation de Spacer pour pousser le texte en bas
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(bottom: 5),
            child: const Text(
              'Version 0.0.1',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar(List<String> MONTHS) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons
                    .lab_flask_solid, // Remplacez par l'icône de votre choix
                color: Colors.black,
              ),
              SizedBox(width: 10), // Espace entre l'icône et le texte
              Text(
                insulinRemaining
                    .toString(), // Conversion en chaîne de caractères
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Text(
            '${DateTime.now().day} ${MONTHS[DateTime.now().month - 1]}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      elevation: 0.0,
      centerTitle: false,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 162, 0, 255).withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/icons/arrow-left.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            // Action à effectuer lorsque le menu est sélectionné
            if (value == 'menu_item_1') {
              // Action pour l'élément de menu 1
            } else if (value == 'menu_item_2') {
              // Action pour l'élément de menu 2
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BasalProfileEditor()),
                    );
                  },
                ),
              ),
              const PopupMenuItem<String>(
                value: 'menu_historique',
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Historique'),
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
          icon: SvgPicture.asset(
            'assets/icons/dots.svg',
            height: 5,
            width: 5,
          ),
          // Icône du bouton de menu
        ),
      ],
    );
  }
}
