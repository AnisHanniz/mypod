import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypod/pages/bdd/database.dart';
import 'package:mypod/pages/bluetooth/pod_dialog.dart';
import 'package:mypod/utils/AppState.dart';
import 'package:mypod/widgets/Bolus/bolus_dialogue.dart';
import 'package:mypod/widgets/PopupMenu/popup_menu_home.dart';
import 'package:mypod/widgets/infos_pod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppState appState = AppState();
  List<InfosPod> topInfos = [];
  List<InfosPod> bottomInfos = [];
  Timer? _timer;
  final database = DatabaseProvider();

  final StreamController<void> _refreshController =
      StreamController<void>.broadcast();

  void _sendRefreshNotification() {
    _refreshController.add(null);
  }

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
        setState(() {
          appState.isConnectedToPump = checkConnectionStatus();
          if (!appState.isConnectedToPump) {
            appState.insulinRemaining = 0;
          } else {
            updateInsulinRemainingFromBluetooth();
            updateConnectionStatus(checkConnectionStatus());
          }
        });
      }
    });
    updateConnectionStatus(checkConnectionStatus());
    _refreshController.stream.listen((_) {
      updateConnectionStatus(checkConnectionStatus());
    });
  }

  bool checkConnectionStatus() {
    return appState.isConnectedToPump;
  }

  void updateInsulinRemainingFromBluetooth() async {
    try {
      double insulinValue = AppState().insulinRemaining;
      if (mounted) {
        setState(() {
          appState.insulinRemaining = insulinValue;
        });
      }
      _sendRefreshNotification(); // Envoyer une notification de rafraîchissement
    } catch (e) {
      print(
          'Erreur lors de la mise à jour du taux d\'insuline (Bluetooth): $e');
    }
  }

  void updateConnectionStatus(bool isConnected) {
    setState(() {
      appState.isConnectedToPump = isConnected;
    });
  }

  Future<void> _loadUserPreferences(Database database) async {
    final utilisateurParams =
        await DatabaseProvider().readUtilisateurParams(database);
    if (utilisateurParams != null) {
      setState(() {
        appState.nom = utilisateurParams['nom'];
        appState.prenom = utilisateurParams['prenom'];
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

  Future<void> initPathProvider() async {
    WidgetsFlutterBinding.ensureInitialized();
    await getApplicationDocumentsDirectory();
  }

  Future<void> initializeAsyncData() async {
    await initPathProvider();
    final databaseProvider = DatabaseProvider();
    final database = await databaseProvider.initDB();
    _getInfosPod(database);

    const interval = Duration(seconds: 5);
    _timer = Timer.periodic(interval, (Timer t) async {
      if (mounted) {
        const basalInsulin = 0;
        try {
          double currentInsulin = appState.insulinRemaining;
          setState(() {
            appState.insulinRemaining = currentInsulin - basalInsulin;
            updateInsulinRemainingFromBluetooth();
          });
        } catch (e) {
          print('Error updating insulin remaining: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _refreshController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: appBar(context),
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
            margin: const EdgeInsets.all(15),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: topInfos.length,
              separatorBuilder: (context, index1) => const SizedBox(width: 25),
              itemBuilder: (context, index) {
                InfosPod info = topInfos[index];
                if (info.widget != null) {
                  return Container(
                    width: 340,
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
                              const SizedBox.shrink(),
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
                  width: 200,
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
            child: ElevatedButton(
              onPressed: appState.isConnectedToPump
                  ? () async {
                      double insulinValue = appState.insulinRemaining;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BolusInputDialog(
                            insulinRemaining: insulinValue,
                            updateInsulinRemaining: (double value) async {
                              updateInsulinRemainingFromBluetooth();
                            },
                          );
                        },
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: appState.isConnectedToPump
                    ? const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9)
                    : Colors.grey,
                padding: const EdgeInsets.all(22),
                elevation: appState.isConnectedToPump ? 5 : 0,
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
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(bottom: 2),
            child: const Text(
              'Version 0.7',
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

  AppBar appBar(BuildContext context) {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat.MMM('fr').format(currentDate);
    final appState = Provider.of<AppState>(context);
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          !appState.isConnectedToPump
              ? ElevatedButton(
                  onPressed: () {
                    showChangePodDialog(context, launchBluetoothState);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Connecter Pod'),
                )
              : Row(
                  children: [
                    const Icon(CupertinoIcons.lab_flask_solid,
                        color: Color.fromARGB(255, 0, 0, 0)),
                    const SizedBox(width: 15),
                    Text(
                      "${appState.insulinRemaining.toString()} U",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
          Text(
            '${currentDate.day} $formattedDate',
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
      actions: const [
        MyPopupMenu(),
      ],
    );
  }
}
