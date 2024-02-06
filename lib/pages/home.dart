import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mypod/main.dart';
import 'package:mypod/pages/bdd/database.dart';
import 'package:mypod/widgets/Bolus/bolus_dialogue.dart';
import 'package:mypod/widgets/Bolus/last_bolus_widget.dart';
import 'package:mypod/widgets/PopupMenu/popup_menu_home.dart';
import 'package:mypod/widgets/infos_pod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<InfosPod> topInfos = [];
  List<InfosPod> bottomInfos = [];
  double insulinRemaining = 200.0; // À charger depuis la pompe
  Timer? _timer;
  final database = DatabaseProvider();
  String nom = '';
  String prenom = '';

  void _getInfosPod(Database db) {
    // Résumé général et profil basal actif pour le haut
    topInfos = [
      InfosPod.getInfosPod(0, db).first,
      InfosPod.getInfosPod(1, db).first,
    ];

    // État du pod et dernier bolus pour le bas
    bottomInfos = [
      InfosPod.getInfosPod(2, db).first, // État du pod
      InfosPod.getInfosPod(3, db).first, // Dernier bolus
    ];
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    initializeAsyncData().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _loadUserPreferences(Database database) async {
    final utilisateurParams =
        await DatabaseProvider().readUtilisateurParams(database);
    if (utilisateurParams != null) {
      // Les données de l'utilisateur sont disponibles, mettez à jour l'état de la page
      setState(() {
        nom = utilisateurParams['nom'];
        prenom = utilisateurParams['prenom'];
      });
    } else {
      // Les données de l'utilisateur n'ont pas été trouvées, vous pouvez gérer ce cas
      // Par exemple, vous pouvez définir des valeurs par défaut pour nom et prénom ici.
    }
  }

  void _initializeData() {
    final databaseProvider = DatabaseProvider();

    databaseProvider.initDB().then((database) {
      _loadUserPreferences(database);
      initializeAsyncData().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  Future<void> initializeAsyncData() async {
    await initPathProvider();
    final databaseProvider = DatabaseProvider();
    final database = await databaseProvider.initDB();
    _getInfosPod(database);

    const interval = Duration(minutes: 5);
    _timer = Timer.periodic(interval, (Timer t) {
      if (mounted) {
        final basalInsulin = 0; // À remplacer avec les valeurs réelles
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
    final controller = PageController(viewportFraction: 0.8);
    return Scaffold(
      appBar: appBar(),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
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
          ),
          Container(
            height: 180,
            margin: EdgeInsets.all(15),
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
                        info.widget!,
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
                  children: [
                    Expanded(
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: info.boxColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (info.widget != null)
                              info.widget!
                            else
                              SizedBox.shrink(),
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
                      ),
                    ),
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
                showDialog(
                  context: context,
                  builder: (context) {
                    return BolusInputDialog(
                      insulinRemaining: insulinRemaining,
                      updateInsulinRemaining: (double value) {
                        // Mettez à jour la valeur de l'insulinRemaining ici
                      },
                    );
                  },
                );
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
              'Version 0.3.0',
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

  AppBar appBar() {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat.MMM('fr').format(
        currentDate); // Format court pour le nom du mois en français (ex: janv, févr, ...)

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
            '${DateTime.now().day} $formattedDate', // Utilisation du mois formaté en français
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
        MyPopupMenu(),
      ],
    );
  }
}

class LastBolusWidget extends StatefulWidget {
  @override
  _LastBolusWidgetState createState() => _LastBolusWidgetState();
}

class _LastBolusWidgetState extends State<LastBolusWidget> {
  String lastBolus = 'Aucun bolus enregistré';
  String dateInjection = '';
  String heureInjection = '';

  @override
  void initState() {
    super.initState();
    getLastBolusFromDatabase(); // Appel de la fonction pour récupérer le dernier bolus
  }

  Future<void> getLastBolusFromDatabase() async {
    try {
      Database database = await openDatabase(
        join(await getDatabasesPath(), 'local.db'),
      );

      final List<Map<String, dynamic>> results = await database.query(
        'historique_injections_bolus',
        orderBy: 'date_injection DESC, heure_injection DESC',
        limit: 1,
      );

      if (results.isNotEmpty) {
        setState(() {
          lastBolus = results[0]['dose'].toString();
          dateInjection = results[0]['date_injection'];
          heureInjection = results[0]['heure_injection'];
        });
      } else {}
    } catch (e) {
      print('Erreur lors de la récupération du dernier bolus : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bolt_rounded), // Icône pour la date
              SizedBox(width: 4.0),
              Text(
                '$lastBolus unités',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), // Espace entre les icônes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today), // Icône pour la date
              SizedBox(width: 4.0),
              Text(
                'le $dateInjection',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), // Espace entre les icônes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time), // Icône pour l'heure
              SizedBox(width: 4.0),
              Text(
                'à $heureInjection',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
