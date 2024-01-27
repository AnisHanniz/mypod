import 'dart:async';
import 'package:flutter_svg/svg.dart';
import 'package:mypod/models/infos_pod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mypod/pages/BasalProfile.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<InfosPod> topInfos = []; // Pour les éléments en haut
  List<InfosPod> bottomInfos = []; // Pour les éléments en bas
  double insulinRemaining = 200.0;
  BasalProfile basalProfile = BasalProfile([]); // Initialiser ici basalProfile
  Timer? _timer;
  double calculateBasalInsulinToAdminister() {
    final now = TimeOfDay.now();
    final basalRate = basalProfile
        .calculateBasalInsulinForTime(now); // Accède à basalProfile ici
    return basalRate;
  }

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

  // Fonction pour administrer un bolus
  void administerBolus() {
    // Par exemple, récupérer la quantité de bolus à administrer

    double bolusAmount = 5.0;
    // A remplacer par la valeur réelle du bolus
    // Envoyer la commande de bolus via BluetoothManager

    // Mise à jour de la quantité restante
    setState(() {
      insulinRemaining -= bolusAmount;
    });
  }

  // dialogue pour saisir la quantité du bolus
  Future<void> showBolusInputDialog() async {
    double bolusAmount = 0.0;
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Entrez la quantité du bolus'),
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
          // Assez d'insuline, administration du bolus
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
                    'L\'insuline restante n\'est pas suffisante pour un bolus.'),
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
    // Résumé général et profil basal actif pour le haut
    topInfos = [
      InfosPod.getInfosPod(0).first,
      InfosPod.getInfosPod(1).first,
    ];

    // État du pod et dernier bolus pour le bas
    bottomInfos = [
      InfosPod.getInfosPod(2).first, // État du pod
      InfosPod.getInfosPod(3).first, // Dernier bolus
    ];
  }

  @override
  void initState() {
    super.initState();
    _getInfosPod();
    const interval = Duration(minutes: 5);
    _timer = Timer.periodic(interval, (Timer t) {
      if (mounted) {
        final basalInsulin = calculateBasalInsulinToAdminister();
        setState(() {
          insulinRemaining -= basalInsulin;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Annule le Timer lorsque le widget est détruit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(MONTHS),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ListView(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        children: [
          const Padding(
            padding: EdgeInsets.all(25),
            child: Center(
              child: Text(
                'myPod',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ), // Intégration du widget de graphique ici
          Container(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: topInfos.length,
              separatorBuilder: (context, index1) => const SizedBox(width: 25),
              itemBuilder: (context, index) {
                InfosPod info = topInfos[index];
                if (info.widget != null) {
                  return Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: info.boxColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        info.widget!, // info.widget est un widget
                        Text(
                          info.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  //résumé général
                  children: [
                    Container(
                      width: 300,
                      height: 120,
                      decoration: BoxDecoration(
                        color: info.boxColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          info.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
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
          Container(
            margin: const EdgeInsets.all(20),
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bottomInfos.length,
              itemBuilder: (context, index) {
                InfosPod info = bottomInfos[index];
                return Container(
                  padding: const EdgeInsets.all(5.0),
                  margin: const EdgeInsets.all(5),
                  width: 160,
                  decoration: BoxDecoration(
                    color: info.boxColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        info.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (info.widget != null) info.widget!,
                    ],
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.all(20),
            child: InkWell(
              onTap: () {
                showBolusInputDialog();
              },
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
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
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(bottom: 2),
            child: const Text(
              'Version 0.0.2',
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
                CupertinoIcons.lab_flask_solid, // Icône
                color: Color.fromARGB(255, 0, 0, 0),
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
